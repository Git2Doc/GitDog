// 1. install Python requirements
resource "null_resource" "install_python_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ${path.root}/../gitdog-example/requirements.txt -t ${path.root}/../gitdog-example/"
  }
}

// 2. Archive the lambda function
data "archive_file" "zip_gitdog_example" {
  type        = "zip"
  source_dir  = "${path.root}/../gitdog-example/"
  output_path = "${path.root}/../gitdog-example.zip"
}

// 3. Archive the lambda function layer
data "archive_file" "layer_gitdog_example" {
  depends_on  = [null_resource.install_python_dependencies]
  type        = "zip"
  source_dir  = "${path.root}/../gitdog-example/"
  output_path = "${path.root}/../gitdog-example-layer.zip"
}

// 4. Create the lambda function layer
resource "aws_lambda_layer_version" "layer_gitdog_example" {
  layer_name          = "gitdog-example-layer"
  filename            = data.archive_file.layer_gitdog_example.output_path
  source_code_hash    = data.archive_file.layer_gitdog_example.output_base64sha256
  compatible_runtimes = ["python3.10"]
  description         = "gitdog-example-layer"
}

// 5. Create the lambda function
resource "aws_lambda_function" "gitdog_example" {
  filename         = data.archive_file.zip_gitdog_example.output_path
  function_name    = "gitdog-example"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.zip_gitdog_example.output_base64sha256
  runtime          = "python3.10"
  layers           = [aws_lambda_layer_version.layer_gitdog_example.arn]

  timeout     = 60
  memory_size = 128
  publish     = true
  tags = {
    Name = "gitdog-example"
  }

  ephemeral_storage {
    size = 1024 # Min 512 MB and the Max 10240 MB
  }
}

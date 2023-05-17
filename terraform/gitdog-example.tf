// 1. Archive the lambda function
data "archive_file" "zip_gitdog_example" {
  type        = "zip"
  source_dir  = "${path.root}/../gitdog-example/"
  output_path = "${path.root}/../gitdog-example.zip"
}

// 2. Create the lambda function
resource "aws_lambda_function" "gitdog_example" {
  filename         = data.archive_file.zip_gitdog_example.output_path
  function_name    = "gitdog-example"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.zip_gitdog_example.output_base64sha256
  runtime          = "python3.10"


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

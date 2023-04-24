// 1. Archive the source code
data "archive_file" "zip_gitdog_example" {
  type        = "zip"
  source_file = "${path.root}/../gitdog-example/lambda.py"
  output_path = "${path.root}/../gitdog-example.zip"
}

// 2. Upload the archive to S3
resource "aws_s3_object" "s3_gitdog_example" {
  bucket = aws_s3_bucket.gitdog-bucket.id
  key    = "gitdog-example.zip"
  source = data.archive_file.zip_gitdog_example.output_path
}

resource "aws_s3_bucket" "api-bucket" {
  bucket        = "mju-gitdog-s3-bucket"
  force_destroy = true
}

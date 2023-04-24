resource "aws_s3_bucket" "gitdog-bucket" {
  bucket        = "mju-gitdog-s3-bucket"
  force_destroy = true
}

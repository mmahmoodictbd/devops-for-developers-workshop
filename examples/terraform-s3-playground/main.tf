provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "b" {
  bucket = "mmahmood-my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
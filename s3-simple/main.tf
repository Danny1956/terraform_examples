provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "example_2019_11_01" {
  bucket = "my-test-s3-terraform-bucket-2019-11-01"

  tags {
    Name = "my-test-s3-terraform-bucket"
  }
}

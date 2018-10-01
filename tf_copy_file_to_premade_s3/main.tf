provider "aws" {
  region = "eu-west-1"
}
resource "aws_s3_bucket_object" "object" {
 bucket = "${var.bucket_name}"
 key    = "${var.bucket_key2}"
 source = "${var.source_file}"
}

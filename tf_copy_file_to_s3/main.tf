provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.bucket1.id}"
  key    = "${var.bucket_key}"
  source = "${var.source_file}"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = "${var.versioning}"
  }
  provisioner "local-exec" {
    command = "echo ${aws_s3_bucket.bucket.arn}} >> bucketarn.txt"
  }
}

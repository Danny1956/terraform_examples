provider "aws"
{
  region = "eu-west-1"
}

module "version_bucket" {
  source = "./s3"
  bucket_name = "ds-versioned"
#  versioning = "true"

}

module "unversioned_bucket"{
  source = "./s3"
  bucket_name = "ds-unversioned"
  versioning = "false"
}

output "versioned_bucket_arn" {
    value = "${module.version_bucket.s3_bucket_arn}"
}

output "unversioned_bucket_arn" {
  value = "${module.unversioned_bucket.s3_bucket_arn}"
}





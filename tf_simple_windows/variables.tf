variable "aws_region" {
  default = "eu-west-1"
}
variable "win_amis" {
  type = "map"
  default = {
    us-east-1 = "ami-96e1f27c"
    us-west-2 = "ami-9f5efbff"
    eu-west-1 = "ami-96e1f27c"
  }
}
#variable "public_key_path" {}
variable "private_key_name" {}
variable "admin-password" {}
variable "admin-username" {}
variable "ps_logs_dir" {
  default = "ps_logs"
}
# hyphens not allowed in ps names...
variable "TranscriptFile"{
  default = "transcript.txt"
}
#simple aws ec2 instance with eip

provider "aws"{
  region = "eu-west-1"
}
resource "aws_instance" "danny-ec2" {

  ami = "ami-7c491f05"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"

  tags {
    Name = "${var.tag_name}",
    Project = "${var.tag_project}"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.danny-ec2.id}"
}

output "aws_instance-ec2_eip"{
  value = "${aws_eip.ip.public_ip}"
}

# Simple aws ubuntu
# install docker and make
#

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "simple-ubuntu" {
  ami                    = "ami-0181f8d9b6f098ec4"
  instance_type          = "t2.micro"
  key_name               = "${var.keyname}"
  #vpc_security_group_ids = ["${aws_security_group.simple-ubuntu-sg.id}"]
  subnet_id = "subnet-0b41eb6f"
  connection {
    type        = "ssh"
    user        = "${var.user_name}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get install docker.io -y",
      "sudo apt-get install make",
      "sudo service docker start",
    ]
  }

  tags {
    Name    = "${var.tag_name}"
    Project = "${var.tag_project}"
  }
}
/*
resource "aws_security_group" "simple-ubuntu-sg" {
  name = "aws-simple-ubuntu-security-group"
  vpc_id = "vpc-127fb276"
  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
*/
/*
output "aws_instance_public_ip" {
  value = "${aws_instance.simple-ubuntu.public_ip}"
}
*/


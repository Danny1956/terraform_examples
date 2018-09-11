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

  connection {
    type = "ssh"
    user        = "${var.user_name}"
    private_key = "${file(var.private_key_path)}"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update && sudo apt-get install docker.io -y",
      "sudo apt-get install make"
    ]
  }

  tags {
    Name    = "${var.tag_name}"
    Project = "${var.tag_project}"
  }
}
output "aws_instance_public_ip" {
  value = "${aws_instance.simple-ubuntu.public_ip}"
}

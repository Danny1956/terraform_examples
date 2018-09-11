# Simple aws ubuntu
# install docker and make
# uses named subnet so external ip address is excluded

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "simple-ubuntu" {
  ami           = "ami-0181f8d9b6f098ec4"
  instance_type = "t2.micro"
  key_name      = "${var.keyname}"
  subnet_id = "${var.subnet_name}"

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

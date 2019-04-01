# Simple aws ubuntu
# Latest ubuntu image

provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] # Canonical
}


resource "aws_instance" "simple-ubuntu" {
  ami           =  "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "${var.keyname}"
  ##subnet_id     = "${var.subnet_name}"

  connection {
    type        = "ssh"
    user        = "${var.user_name}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo apt-get update -y && sudo apt-get upgrade -y",
    "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config",
    "sudo /etc/init.d/ssh restart",
    "sudo apt install xrdp xfce4 xfce4-goodies tightvncserver -y",
    "sudo echo xfce4-session /home/ubuntu/.xsession",
    "sudo cp /home/ubuntu/.xsession /etc/skel/",
    "sudo service xrdp restart"
    
    
    ]
  }

  tags {
    Name    = "${var.tag_name}"
    Project = "${var.tag_project}"
  }
}

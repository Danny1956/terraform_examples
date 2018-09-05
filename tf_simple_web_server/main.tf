#simple aws web server

provider "aws"{
  region = "eu-west-1"
}
resource "aws_instance" "simple-webserver" {

  ami = "ami-0181f8d9b6f098ec4"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  vpc_security_group_ids = ["${aws_security_group.simple-web-server-sg.id}"]
  user_data = <<-EOF
       #!/bin/bash
       echo "Hello, World" > index.html
       nohup busybox httpd -f -p "${var.server_port}" &
       EOF

  tags {
    Name = "${var.tag_name}",
    Project = "${var.tag_project}"
  }
}
resource "aws_security_group" "simple-web-server-sg" {
 name  = "aws-web-server-security-group"


  ingress {
    from_port = "${var.server_port}"
    protocol = "tcp"
    to_port = "${var.server_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

output "aws_instance_public_ip" {
  value = "${aws_instance.simple-webserver.public_ip}"
}
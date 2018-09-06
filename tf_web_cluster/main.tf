#simple aws web cluster

provider "aws" {
  region = "eu-west-1"
}

resource "aws_launch_configuration" "simple-webcluster" {
  image_id        = "ami-0181f8d9b6f098ec4"
  instance_type   = "t2.micro"
  key_name        = "${var.keyname}"
  security_groups = ["${aws_security_group.simple-web-cluster-sg.id}"]

  user_data = <<-EOF
       #!/bin/bash
       echo "Hello, World" > index.html
       nohup busybox httpd -f -p "${var.server_port}" &
       EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "simple-web-cluster-sg" {
  name = "aws-web-cluster-security-group"

  ingress {
    from_port   = "${var.server_port}"
    protocol    = "tcp"
    to_port     = "${var.server_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_availability_zones" "available" {}

resource "aws_autoscaling_group" "cluster_autoscaling_group" {
  launch_configuration = "${aws_launch_configuration.simple-webcluster.id}"
  availability_zones   = ["${data.aws_availability_zones.available.names}"]
  max_size             = 10
  min_size             = 2
  load_balancers       = ["${aws_elb.aws-elb-for-cluster.name}"]
  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "Terraform-asg-example"
  }
}

resource "aws_elb" "aws-elb-for-cluster" {
  name               = "terraform-asg-example"
  availability_zones = ["${data.aws_availability_zones.available.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    target              = "HTTP:${var.server_port}/"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elb_dns_name" {
  value = "${aws_elb.aws-elb-for-cluster.dns_name}"
}

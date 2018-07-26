
provider "aws"{
  region = "eu-west-1"
}
resource "aws_instance" "nginx" {
  ami = "${var.ami_name}"

  instance_type = "t2.micro"
  key_name = "${var.keyname}"

  connection {
    user = "${var.user_name}"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rpm -ivh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm",
      "sudo yum install nginx -y",
      "sudo service nginx start"
    ]
  }

}

output "aws_instance_public_dns" {
  value = "${aws_instance.nginx.public_dns}}"
}


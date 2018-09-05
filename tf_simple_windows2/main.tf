/***********************************************************

Simple windows tf creation

Includes WinRM

remember to d/l and install ec2config on ec2 windows
client to invoke start up scripts at boot time.

***********************************************************/

provider "aws"{
  region = "${var.aws_region}"
}

# Default security group to access the instances via WinRM over HTTP and HTTPS
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"

  # WinRM access from anywhere
  ingress {
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # RDP access 
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }




  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "winrm" {
  ami = "${lookup(var.win_amis,var.aws_region)}"
  instance_type = "t2.micro"
  key_name = "${var.private_key_name}"
  security_groups = ["${aws_security_group.default.name}"]
  user_data = <<EOF
   <script>
    winrm quickconfig -q
    winrm set winrm/config/winrs ‘@{MaxMemoryPerShellMB=”300″}’
    winrm set winrm/config ‘@{MaxTimeoutms=”1800000″}’
    winrm set winrm/config/service ‘@{AllowUnencrypted=”true”}’
    winrm set winrm/config/service/auth ‘@{Basic=”true”}’

   <script>
   
   
    <powershell>
    net user ${var.admin-username} ${var.admin-password} /add /y
    net localgroup administrators ${var.admin-username} /add
    net localgroup "remote management users" ${var.admin-username} /add
  
    $file = $env:SystemRoot + "\Temp\" + (Get-Date).ToString("MM-dd-yy-hh-mm")
    New-Item $file -ItemType file

    netsh advfirewall firewall add rule name=”WinRM 5985″ protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name=”WinRM 5986″ protocol=TCP dir=in localport=5986 action=allow
    #Set-NetFirewallRule -Name “WINRM-HTTP-In-TCP-PUBLIC” -RemoteAddress “Any”
    
    net stop winrm
    sc.exe config winrm start=auto
    net start winrm
    </powershell>

  EOF


  connection {
    type = "winrm"
    timeout = "10m"
    user = "${var.admin-username}"
    password = "${var.admin-password}"
  }
}

output "aws_instance_public_ip"{
  value = "${aws_instance.winrm.public_dns}"
  }

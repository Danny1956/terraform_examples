
provider "aws"{
  region = "eu-west-1"
}
resource "aws_instance" "win-example" {
  ami = "${lookup(var.win_amis,var.aws_region)}"

  instance_type = "t2.micro"
  key_name = "${var.private_key_name}"




  user_data = <<EOF

  <script>
    winrm quickconfig -q
    winrm set winrm/config/winrs ‘@{MaxMemoryPerShellMB=”300″}’
    winrm set winrm/config ‘@{MaxTimeoutms=”1800000″}’
    winrm set winrm/config/service ‘@{AllowUnencrypted=”true”}’
    winrm set winrm/config/service/auth ‘@{Basic=”true”}’
  </script>

 <powershell>
    md c:\temp
    cd c:\temp
    echo "hello" > c:\temp\sfsdfd.txt
    netsh advfirewall firewall add rule name=”WinRM 5985″ protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name=”WinRM 5986″ protocol=TCP dir=in localport=5986 action=allow
    net user ${var.admin-username} ${var.admin-username} /add /y
    net localgroup administrators ${var.admin-username} /add
    md ${var.ps_logs_dir}
    cd ${var.ps_logs_dir}
    start-transcript ${var.TranscriptFile}

</powershell>
EOF


  connection {
    type = "winrm"
    timeout = "10m"
    user = "${var.admin-username}"
    password = "${var.admin-password}"
  }
}


/*************************************************

# in the event of using template file

data "template_file" "init" {
  template = "${file("ps_init.tpl")}"
  vars {
    admin-username = "${var.admin-username}"
    ps_logs_dir = "${var.ps_logs_dir}"
    TranscriptFile = "${var.TranscriptFile}"
    }
}
**************************************************/

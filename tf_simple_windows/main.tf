/***********************************************************

Simple windows tf creation
Also creates an bucket

remember to d/l and install ec2config on ec2 windows
client to invoke start up scripts at boot time.

***********************************************************/



provider "aws"{
  region = "eu-west-1"
}
resource "aws_instance" "win-example" {
  ami = "${lookup(var.win_amis,var.aws_region)}"

  instance_type = "t2.micro"
  key_name = "${var.private_key_name}"
  #dependency below not necessary for windows, but want to
  #be able to copy from it
  depends_on = ["aws_s3_bucket_object.object"]

  user_data = <<EOF

  <script>
    winrm quickconfig -q
    winrm set winrm/config/winrs ‘@{MaxMemoryPerShellMB=”300″}’
    winrm set winrm/config ‘@{MaxTimeoutms=”1800000″}’
    winrm set winrm/config/service ‘@{AllowUnencrypted=”true”}’
    winrm set winrm/config/service/auth ‘@{Basic=”true”}’
  </script>

 <powershell>
    start-transcript ${var.TranscriptFile}

    md ${var.temp_dir}
    cd ${var.temp_dir}

    echo "hello" > ${var.temp_dir} + "\" + ${var.hello_txt_file}

    md c:\temp
    $file = "c:\temp\"+ (Get-Date).ToString("MM-dd-yy-hh-mm")
    New-Item $file -ItemType file

    netsh advfirewall firewall add rule name=”WinRM 5985″ protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name=”WinRM 5986″ protocol=TCP dir=in localport=5986 action=allow
    net user ${var.admin-username} ${var.admin-username} /add /y
    net localgroup administrators ${var.admin-username} /add
    md ${var.ps_logs_dir}
    cd ${var.ps_logs_dir}
    # create a test file
    $file = "c:\temp
    stop-transcript
</powershell>
EOF


  connection {
    type = "winrm"
    timeout = "10m"
    user = "${var.admin-username}"
    password = "${var.admin-password}"
  }
}

/************************************************************
create and copy small local file to s3
bucket


*************************************************************/

resource "aws_s3_bucket" "bucket1" {
  bucket = "${var.bucket_name}"
}

resource "aws_s3_bucket_object" "object" {
  bucket = "${var.bucket_name}"
  key = "${var.bucket_key}"
  source = "${var.source_file}"
  depends_on = ["aws_s3_bucket.bucket1"]
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

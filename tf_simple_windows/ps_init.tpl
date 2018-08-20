<powershell>
    md c:\temp
    cd c:\temp
    echo "hello" > c:\temp\sfsdfd.txt
    netsh advfirewall firewall add rule name=”WinRM 5985″ protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name=”WinRM 5986″ protocol=TCP dir=in localport=5986 action=allow
    net user ${admin-username} ${admin-username} /add /y
    net localgroup administrators ${admin-username} /add
    md ${ps_logs_dir}
    cd ${ps_logs_dir}
    start-transcript ${TranscriptFile}

</powershell>
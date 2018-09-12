
    $tempPath = "c:\temp"
    $transcriptfile = $tempPath + "\transcript_" +(Get-Date).ToString("yyyy-MM-dd-hh-mm-ss") +".txt"
    if (-not (Test-Path $tempPath))
        {md $tempPpath}
    
    start-transcript $transcriptfile
    
    $file = $tempPath + "\" + (Get-Date).ToString("yy-mm-dd-hh-mm-ss")
    New-Item $file -ItemType file

    Import-Module 'c:\ps\fn_unzip.ps1' -Force

    Unzip "C:\ps\backups.zip" "C:\temp2"

    stop-transcript


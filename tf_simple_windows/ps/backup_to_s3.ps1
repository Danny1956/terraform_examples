<#

    backup our scheduled tasks directory
    and ssis jobs.    

#>



$TranscriptPath = "c:\ps"
$transcriptfile = $TranscriptPath + "\transcript_" +(Get-Date).ToString("yyyy-MM-dd-hh-mm-ss") +".txt"
Start-Transcript -Path  $Transcriptfile

$s3_bucket_name  = "ds-test1111-bucket"


#back up to logs drive to start with (as this is on a different volume).
$backup_details_file = "c:\ps\file_backup_locations.txt"
$backups = (Get-Content -Path $backup_details_file) -notmatch '#'


 foreach($x in $backups)
    {
         #init derived fields
         $source      = ""
         $destination = ""
 
         #get values from array
         $source, $destination = $x -split "="

         Write-Host '#'  $source
         Write-Host '#'  $destination

                 
         if (Test-Path $destination) {Remove-Item $destination}
         Add-Type -AssemblyName "system.io.compression.filesystem"
         [io.compression.zipfile]::createFromDirectory($source, $destination)


         Write-S3Object -BucketName $s3_bucket_name -File $destination
        # Add-Content    $Transcriptfile  "Backing up $dbToBackup"


    }

    Stop-Transcript


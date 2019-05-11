# Robocopy docs: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
# Powershell <-> XML docs: https://www.business.com/articles/powershell-read-xml-files/

function main {
    backup-files
}

function backup-files{
    write-host "Backing up..." -ForegroundColor Yellow

    $xmlConfig = [XML](Get-Content .\config.xml)
    $sources = $xmlConfig.Config.Source
    md -Force $xmlConfig.Config.DestinationDirectory
    $datedFolder = $xmlConfig.Config.DestinationDirectory + '\' + ((Get-Date).ToString('yyyy-MM-dd'))
    New-Item -ItemType Directory -Path $datedFolder

    foreach ($Source in $sources){
        Try {
            $destDirName = $datedFolder + '\' + $Source.DestinationName
            New-Item -ItemType Directory -Path $destDirName
            $SourceDir = $Source.SourceDirectory
            $exDirectories = $Source.ExcludeDirectories.Dir
            $exFiles = $Source.ExcludeFiles.File
            # Create the logfile name
            $Logfile = $destDirName + '\backup' + '.log'
            Start-Transcript $Logfile -NoClobber
            Robocopy $SourceDir $destDirName /MIR /256 /xd $exDirectories /xf $exFiles /r:1 /w:1
            Stop-Transcript
        } Catch {
            Write-Host "An error occurred:" $PSItem -ForegroundColor Red
        }
    }
    write-Host ""
    write-Host "Done!" -ForegroundColor Green
    write-Host ""
    Start-Sleep -s 2
}

main

# Possible improvements:
#	Default destination folder
#	Retention days (delete if more than X days old)
#	Back up the XML config file too
# Zip the backed-up folder

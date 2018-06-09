# Documentation: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
# Handy: http://www.tomsitpro.com/articles/powershell-read-xml-files,2-895.html


md -Force D:\Backups

$xmlConfig = [XML](Get-Content $env:USERPROFILE\Documents\ps-drive-project\config.xml)
$sources = $xmlConfig.Config.Source
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
    }
    Catch {
    Write-Host "An error occurred:" $PSItem
    }
}


#XML needs:
#	Default destination folder
#	Retention days (delete if more than X days old)
#	Backup XML config file too? Yes.

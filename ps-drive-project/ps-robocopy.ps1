# Roboxopy docs: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
# Powershell <-> XML docs: http://www.tomsitpro.com/articles/powershell-read-xml-files,2-895.html

function main {
    Confirm-Backup
}


# Get user response if they'd like to run a backup
function Confirm-Backup {
    $posAnswers = "Yes","Yep","Ya","Yaa","Yaas","Yep","Yup","Yip","Y","Ye","Yars","Yea","Yeah","Yaas","Yeh","Yah"
    $negAnswers = "No","Na","Nah","Nop","Nope","Nup","N","Neg"
    $counter = 0
    Do{
        Write-host "Would you like to backup your files?" -ForegroundColor Yellow 
        $answer = Read-Host 
        if ($answer -in $posAnswers){
            Do-The-Copying('yes')
        }
        elseif ($answer -in $negAnswers){
            Do-The-Copying('no')
        }
        # Too many invalid responses will cause exit
        else {
            $counter++
            #write-host "Counter =" $counter
            switch ($counter)
            {
                1 { Write-Host "Answer yes or no" -ForegroundColor Red }
                2 { write-Host "Last chance! Yes or no?" -ForegroundColor Red }
                3 { Write-Host "Fine!"; Do-The-Copying('no') }
            }
        }
    } While ($counter -le 3)
}


function Do-The-Copying($confirmation){
    if($confirmation -eq 'yes'){
        write-host "Backing up in..." -ForegroundColor Yellow
        write-host "3..." -ForegroundColor Yellow; Start-Sleep -s 1
        write-host "2..." -ForegroundColor Yellow; Start-Sleep -s 1
        write-host "1..." -ForegroundColor Yellow; Start-Sleep -s 1
        write-host "Go!" -ForegroundColor Yellow
        
        md -Force D:\Backups
        
        # $env:USERPROFILE
        $xmlConfig = [XML](Get-Content .\config.xml)
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
            Write-Host "An error occurred:" $PSItem -ForegroundColor Red
            }
        }
        write-Host ""
        write-Host "Done!"
        write-Host ""
        Start-Sleep -s 2
    }
    # Don't want to backup
    else {
        Write-Host "Okay, I won't backup." -ForegroundColor Yellow
        # Do nothing
    }
    Read-Host "Press any key to exit..."
    exit
}


# Run the main function
main


#XML needs:
#	Default destination folder
#	Retention days (delete if more than X days old)
#	Backup XML config file too? Yes.

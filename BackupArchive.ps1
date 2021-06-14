########################################################
# Name: BackupScript.ps1                              
# Creator: FNLeaf                    
# CreationDate: 06.15.2021                           
# LastModified: 06.15.2021                               
# Version: 1.0   
#
# Description: Copies the Backup directory to the destination
# First: The script replicates the folder structure of production to archive
# Second: The script lists all of the folders in the productionpath
# Third: For each listed folder, it lists out all files in the subfolder except for the latest file
# Fourth: It moves the listed files to the same folder hierarchy in the archive folder
# Lastly, the script deletes all of the files in each subfolder in archivefolder except for the latest 2 files

# Notes: Please ensure backups are renamed after its date and time to ensure backup names are unique
# eg. For pc ASSE08 backup up on June 15, 2021
# Filename: ASSE08_05152021.v2i (The filename is in format <PCName_or_PCCode>_<MMDDYYYY>.<Backup_Extension>
# The Script is not backwards compatible, so anything that is deleted under the Production folder path is not replicated on the archive folder
$PRODUCTIONPATH = "\\localhost\d$\temp\prod"
$ARCHIVEPATH = "\\localhost\d$\temp\arch"
$LOGPATH = '\\localhost\d$\temp\output.txt'
robocopy $PRODUCTIONPATH $ARCHIVEPATH /e /xf * /log+:output.log
#xcopy /t /e $PRODUCTIONPATH $ARCHIVEPATH /L /D >>$LOGPATH
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path $LOGPATH -append


$FOLDERLIST = Get-ChildItem $PRODUCTIONPATH -Recurse -Directory
foreach($FOLDER in $FOLDERLIST.fullname){
   
    Get-ChildItem -Path $FOLDER | where{-not $_.PsIsContainer}| sort CreationTime -desc | Select-Object -Skip 1|ForEach-Object {
    $dst = $_.FullName.Replace($PRODUCTIONPATH, $ARCHIVEPATH)
    $dir = [IO.Path]::GetDirectoryName($dst)
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
        New-Item -Type Directory -Path $dir | Out-Null
    }
    
    move-Item -Path $_.FullName -Destination $dst -Force -WhatIf
    move-Item -Path $_.FullName -Destination $dst -Force
    }
}

$ARCH_FOLDERLIST = Get-ChildItem $ARCHIVEPATH -Recurse -Directory
foreach($ARCH_FOLDER in $ARCH_FOLDERLIST.fullname){
   
    Get-ChildItem -Path $ARCH_FOLDER | where{-not $_.PsIsContainer}| sort CreationTime -desc | Select-Object -Skip 2|ForEach-Object {
    $DELETE = $_.FullName
    Remove-Item $DELETE -WhatIf
    Remove-Item $DELETE
   
    }
}
Stop-Transcript





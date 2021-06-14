# FileArchScript
Backup and archiving script

# Name: BackupArchive.ps1                              
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

*The script is useful for archiving or backup given that there are multiple workstations connected to a single repository for backup files

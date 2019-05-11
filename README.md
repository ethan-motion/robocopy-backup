# robocopy-backup
This is a simple PowerShell script to back up specified folders and files to
an external drive, or another directory on the same drive.

It could be invoked manually, or added as a scheduled task.

## Config

Only the ```config.xml``` file needs configuration for the robocopy-backup
script to work.

```DestinationDirectory```
The backup destination directory. In here will be a series of folders
formatted yyyy-MM-dd.

```Source (Name)```
The name of the source directory to back up. Optional - just for readability.

```SourceDirectory```
The directory path to be backed up (recursively).

```ExcludeDirectories```
Directories within the SourceDirectory to be ignored.

```ExcludeFiles```
Specific Files within the SourceDirectory to be ignored.

```DestinationName```
Name of the directory that the SourceDirectory will be copied into (likely
to be the same).

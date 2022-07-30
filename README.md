# PiBackup #
This is a little bash script to backup your Pi easyli to a SMB, NFS or local path. To automatically shrink the image file PiShrink is used in the script. More information about PiShrink can be found at the following link: https://github.com/Drewsif/PiShrink
## Usage ##
```
Usage: pibackup.sh [OPTIONS] DESTINATION PATH

        -s      Target is SMB Share
        -n      Target is NFS Share
        -u      [USERNAME] The user required for SMB Share login
        -p      [PASSWORD] The password required for SMB Share login
```
* `-s` Defines the destination directory as an SMB share. If the argument is used, the `-u` and `-p` arguments must also be specified.
* `-n` Defines the destination directory as an NFS share.
* `-u` Defines the username used for authentication on the SMB share. Example `-u User`
* `-p` Defines the password used for authentication on the SMB share. Example `-p Password`

Examples:

For a local target like an external hard disk or a USB stick:
```
pibackup.sh /mnt/USB
```
If the target is an SMB share:
```
pibackup.sh -s -u USER -p PASSWORD //SERVER/SHARE
```
If the target is an NFS share:
```
pibackup.sh -n //SERVER/SHARE
```
## Installation ##

```
wget https://raw.githubusercontent.com/Syc0nd/PiBackup/main/pibackup.sh
chmod +x pibackup.sh
sudo mv pibackup.sh /usr/local/bin
```
## Contributing ##

If you find a bug please create an issue for it. If you would like a new feature added, you can create an issue for it but I can't promise that I will get to it.
#!/bin/bash

script_name="${0##*/}"
script_version="v0.1"
backup_path=$1

function help() {
    cat << END
    ----------------------
    $script_name $script_version
    ----------------------

    Usage: $0 [OPTIONS] DESTINATION PATH

        -s      Target is SMB Share
        -n      Target is NFS Share
        -u      [USERNAME] The user required for SMB Share login
        -p      [PASSWORD] The password required for SMB Share login


END
}

is_smb=false
is_nfs=false

function utils_check() {
    if [ -d "/etc/apt/" ];
        then
        apt install cifs-utils nfs-common -y > /dev/null 2>&1
        else
        dnf install cifs-utils nfs-utils -y > /dev/null 2>&1
    fi
}

while getopts ":hsnup" opt;
do
    case "${opt}" in
        h) help
           exit;;
        s) is_smb=true;;
        n) is_nfs=true;;
        u) smb_user=${OPTARG};;
        p) smb_pw=${OPTARG};;
        *) help
           exit;;
    esac
done

if [ "$is_smb" = true ];
    then
    utils_check
    mkdir /pibackup
    mount cifs -o username=$smb_user,password=$smb_pw $backup_path /pibackup
    backup_path=pibackup
fi

if [ "$is_nfs" = true ];
    then
    utils_check
    mkdir /pibackup
    mount $backup_path /pibackup
    backup_path=pibackup
fi

if [ -f '/usr/local/bin/pishrink.sh' ];
    then
    echo 'pishrink is already installed'
    else
    wget -O /tmp/pishrink.sh https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh
    chmod +x /tmp/pishrink.sh
    mv /tmp/pishrink.sh /usr/local/bin/pishrink.sh
fi

if [ -b /dev/mmcblk0 ];
    then
    main_dev="/dev/mmcblk0"
    else
    main_dev="/dev/sda"
fi

dd if=$main_dev of=/$backup_path/backup_$(hostname)_$(date +%d-%m-%Y)_raw.img bs=1MB status=progress

if [[ $(lsb_release -i) = *Raspbian* ]];
    then
    pishrink.sh -v /$backup_path/backup_$(hostname)_$(date +%d-%m-%Y)_raw.img /$backup_path/backup_$(hostname)_$(date +%d-%m-%Y).img
    rm -rf /$backup_path/backup_$(hostname)_$(date +%d-%m-%Y)_raw.img
    else
    pishrink.sh -s -v /$backup_path/backup_$(hostname)_$(date +%d-%m-%Y)_raw.img /$backup_path/backup_$(hostname)_$(date +%d-%m-%Y).img
    rm -rf /$backup_path/backup_$(hostname)_$(date +%d-%m-%Y)_raw.img
fi

if [ "$is_smb" = true ] || [ "$is_nfs" = true ];
    then
    umount /pibackup
    rm -rf /pibackup
fi
echo 'Backup abgeschlossen'
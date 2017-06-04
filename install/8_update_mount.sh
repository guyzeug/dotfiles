#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

###########################################################################
# Main
###########################################################################

# Update fstab with nas mount
echo
echo "Backup fstab"
sudo cp /etc/fstab /etc/fstab.bak

echo
echo "Content of fstab before update"
cat /etc/fstab

pause

echo
echo "Retrieve user UID and GID"
uid=$(sh -c -e "id -u")
gid=$(sh -c -e "id -g")
echo "uid: $uid"
echo "gid: $gid"

echo
echo -n "Enter username for nas mount: "
read username
echo -n "Enter password for nas mount: "
read password

echo
echo "Update fstab"
sudo -- sh -c -e "echo '# map nas folders' >> /etc/fstab"
sudo -- sh -c -e "echo '//nas/video /home/guillaume/nas/video cifs rwser=$username,password=$password=$uid,gid=$gid=utf8  0 0' >> /etc/fstab"

echo
echo "Content of fstab after update"
cat /etc/fstab

pause

echo
echo "Refresh mounts"
sudo mount -a

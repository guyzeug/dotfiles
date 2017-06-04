#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

###########################################################################
# Main
###########################################################################

# Update hosts with clouco and nas
echo
echo "Content of /etc/hosts before update"
cat /etc/hosts

sudo -- sh -c -e "echo '192.168.1.124 nas' >> /etc/hosts"

echo
echo "Content of /etc/hosts after update"
cat /etc/hosts

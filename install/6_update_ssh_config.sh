#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

###########################################################################
# Main
###########################################################################

# Update hosts
echo "Generate ~/.ssh/config with clouco and nas"

pause

echo "Host nas
    HostName nas
    Port 22
    User admin" >> ~/.ssh/config

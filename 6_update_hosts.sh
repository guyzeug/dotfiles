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
    User admin

Host clouco
    HostName 75.126.154.152
    Port 2604
    User gopagoda

Host cloucospaces
    HostName 75.126.154.152
    Port 3791
    User gopagoda" >> ~/.ssh/config

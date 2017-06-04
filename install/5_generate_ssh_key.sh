#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

###########################################################################
# Main
###########################################################################

echo
echo "List ~/.ssh folder content to see if existing ssh keys are already present"
ls -al ~/.ssh

echo
echo "Abort if existing SSH keys are already present"

pause

echo
echo "Generate new SSH key (press [Enter] for each question)"
ssh-keygen -t rsa -b 4096 -C "legorrecg@gmail.com"

echo
echo "Start the ssh-agent in the background (expected: 'Agent pid {number}')"
eval $(ssh-agent -s)

echo
echo "Add SSH private key to the ssh-agent"
ssh-add ~/.ssh/id_rsa

echo
echo "Here is the content of the SSH key, add it to your Github account"
cat ~/.ssh/id_rsa.pub

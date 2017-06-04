#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

###########################################################################
# Main
###########################################################################

# Download and install the Moka icon theme (which is the fallback icon theme for Arc)
cd ~/Download
git clone https://github.com/moka-project/moka-icon-theme.git

pause

cd moka-icon-theme/
bash autogen.sh

pause

make

pause

sudo make install

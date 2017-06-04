#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

###########################################################################
# Main
###########################################################################

# Download and install the Arc icon theme
cd ~/Download
git clone https://github.com/horst3180/arc-icon-theme --depth 1 && cd arc-icon-theme

pause

./autogen.sh --prefix=/usr

pause

sudo make install

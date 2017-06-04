#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

###########################################################################
# Main
###########################################################################

# Download and install the Arc-Flatabulous theme
cd ~/Download

# Important: Remove all older versions of the theme from your system before you proceed any further.
sudo rm -rf /usr/share/themes/{Arc-Flatabulousrc-Flatabulous-Darkerrc-Flatabulous-Dark}
rm -rf ~/.local/share/themes/{Arc-Flatabulousrc-Flatabulous-Darkerrc-Flatabulous-Dark}
rm -rf ~/.themes/{Arc-Flatabulousrc-Flatabulous-Darkerrc-Flatabulous-Dark}

pause

git clone https://github.com/andreisergiu98/arc-flatabulous-theme && cd arc-flatabulous-theme

pause

./autogen.sh --prefix=/usr

pause

sudo make install

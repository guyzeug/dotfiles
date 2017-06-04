#!/bin/bash

# Pause
function pause(){
    read -p "Press [Enter] to continue..."
}

# Gets simple (c)ontinue (q)uit response from user. Loops until
# one of those responses is detected.
################################################################################
continue_quit()
{
    local ok=0
    response=""
    # loop until we get a good answer and break out
    # while [ $ok = 0 ]
    while [ true ]
    do
        # Print the message
        echo
        echo $1
        echo -n "#### Press 'c' to continue or 'q' to quit (c/q)"
        # Now get some input
        read input
        if [ -z $input ]
        then
            # Invalid input - null
            echo "INPUT ERROR: Must be 'c' or 'q' in lowercase. Please try again."
        elif [ $input = "continue" ] || [ $input = "c" ]
        then
            response="c"
            break
        elif [ $input = "q" ] || [ $input = "quit" ]
        then
            response="q"
            break
        else
            # Invalid input
            echo "INPUT ERROR: Must be 'c' or 'q' in lowercase. Please try again."
        fi
    done
}


# Gets simple (y)es (n)o (q)uit response from user. Loops until
# one of those responses is detected.
################################################################################
yes_no_quit()
{
    local ok=0
    response=""
    # loop until we get a good answer and break out
    # while [ $ok = 0 ]
    while [ true ]
    do
        # Print the message
        echo
        echo -n "$1 (y/n/q)"
        # Now get some input
        read input
        if [ -z $input ]
        then
            # Invalid input - null
            echo "INPUT ERROR: Must be y or n or q in lowercase. Please try again."
        elif [ $input = "yes" ] || [ $input = "y" ]
        then
            response="y"
            break
        elif [ $input = "no" ] || [ $input = "n" ]
        then
            response="n"
            break
        elif [ $input = "q" ] || [ $input = "quit" ]
        then
            response="q"
            break
        else
            # Invalid input
            echo "INPUT ERROR: Must be y or n or q in lowercase. Please try again."
        fi
    done
}

# Continue or Quit
###########################################################################
continue_or_quit()
{
    echo "$1"
    local retval=$( continue_quit  )
    echo "$retval"
    if [ "$retval" == "q" ]
    then
        echo "Exiting..."
        exit 1
    fi
}

###########################################################################
# Main
###########################################################################
# error=0
# verbose=1
# Msg=""

# Check for root
# if [ `id -u` != 0 ]
# then
#     Msg="You must be root to run this program"
#     PrintMsg
#     error=3
#     Quit $error
# fi

sudo apt update
sudo apt full-upgrade

# Install VMWare tools if necessary
yes_no_quit "Is this install running in VMWare?"
if [ "$response" == "q" ]
then
    echo "Exiting..."
    exit 1
elif [ "$response" == "y" ]
then
    sudo apt install open-vm-tools-desktop || pause
else
    echo skip install vmtools
fi

# Manually install proprietary drivers
continue_quit "#### Manually install / update the drivers"
if [ $response == "q" ]
then
    echo "Exiting..."
    exit 1
fi

# Install git & vim
sudo apt install git || pause
sudo apt install vim || pause

# Install hp utility
sudo apt install hplip-gui || pause

# Install Chrome manually
continue_quit "#### Manually install Chrome"
if [ $response == "q" ]
then
    echo "Exiting..."
    exit 1
fi

# Install Dropbox manually
continue_quit "#### Manually install Dropbox"
if [ $response == "q" ]
then
    echo "Exiting..."
    exit 1
fi

continue_quit "#### WARNING: make sure the Dropbox folder 'Photos/Photos NAS' is NOT ticked"
if [ $response == "q" ]
then
    echo "Exiting..."
    exit 1
fi

continue_quit "#### WARNING: make sure dotfiles folder has been fully downloaded"
if [ $response == "q" ]
then
    echo "Exiting..."
    exit 1
fi

# Increase the disk space by limiting the reserved space for root to 2%
echo "Increase the disk space by limiting the reserved space for root to 2%"
sudo tune2fs -m 2 /dev/sda1

# Disable hibernation
echo "Disable hibernation"
sudo mv -v /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla /

# Install Firejail
echo "Install Firejail to sandbox applications"
sudo apt install firejail || pause

echo "Install complete"

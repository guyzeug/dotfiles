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

# Manually install proprietary drivers and restart
continue_quit "#### Manually install / update the drivers and restart"
if [ $response == "q" ]
then
    echo "Exiting..."
    exit 1
fi

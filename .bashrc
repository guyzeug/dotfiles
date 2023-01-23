# Control ls command output
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'

#alias c='clear'

# Control cd command behavior
alias cd..='cd ..' # get rid of command not found

alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'

#If you pass no arguments, it just goes up one directory.
#If you pass a numeric argument it will go up that number of directories.
#If you pass a string argument, it will look for a parent directory with that name and go up to it.
function up()
{
    dir=""
    if [ -z "$1" ]; then
        dir=..
    elif [[ $1 =~ ^[0-9]+$ ]]; then
        x=0
        while [ $x -lt ${1:-1} ]; do
            dir=${dir}../
            x=$(($x+1))
        done
    else
        dir=${PWD%/$1/*}/$1
    fi
    cd "$dir";
}

# Colorize the grep command output for ease of use (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Create parent directories on demand
alias mkdir='mkdir -pv'

# History
alias h='history'

# grep command history.  Uses function so a bare 'hg' doesn't just hang waiting for input.
function hg() {
  if [ -z "$1" ]; then
    echo "Bad usage. try:hg run_test";
  else
    history | grep $*
  fi
}

# Typing ‘r’ repeats the last command
alias r="fc -e -"

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias edit='vim'
alias vi=vim # GLG: not necessary on mac, To be tested on Linux
alias j='jobs -l'
alias ping_x5='ping -c 5' # Stop after sending 5 ECHO_REQUEST packets
alias ping_fast_x100='ping -c 100 -i.2' # Do not wait interval 1 second, go fast

# Use netstat command to quickly list all TCP/UDP port on the server
# GLG: does not work on mac, does it on Linux ?
alias ports='netstat -tulanp'

# Add safety nets
# -------------------------------
# Do not delete / or prompt if deleting more than 3 files at a time
# NEVER DO alias rm=... (otherwise on another machine you might call 'rm' expecting the safety net where it isn't there)
#GLG: does not work on mac, probably because of --preserve-root, to be tested on Linux
alias del='rm -I --preserve-root'

# confirmation #
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias psg='ps -ef | grep -v $$ | grep -i ' # Processes filtered based on param (excluding the grep of the current line)
alias psme='psg $USER' # My processes
# OR with --color=always (to be tested on mac and linux)
# alias psme='ps -ef | grep $USER --color=always'
# OR with --color=auto (to be tested on mac and linux)
# alias psme='ps -ef | grep $USER --color=auto'

alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'" # File tree

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

alias bashrc='vim Dev/dotfiles/.bashrc && source Dev/dotfiles/.bashrc'

eval "$(starship init bash)"

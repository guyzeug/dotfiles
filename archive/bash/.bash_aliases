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
alias j='jobs -l'
alias ping_x5='ping -c 5' # Stop after sending 5 ECHO_REQUEST packets
alias ping_fast_x100='ping -c 100 -i.2' # Do not wait interval 1 second, go fast

# Add safety nets
# -------------------------------
# Do not delete / or prompt if deleting more than 3 files at a time
# NEVER DO alias rm=... (otherwise on another machine you might call 'rm' expecting the safety net where it isn't there)
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

alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'" # File tree


alias external_ip='curl ifconfig.me'

# list folders by size in current directory
alias usage='du -h --max-depth=1 | sort -rh'

# Git
alias g="git"
alias gr="git rm"
alias grrf="git rm -rf"
alias gs="git status"
alias ga="g add"
alias gaa="g add ."
alias gaaa="g add -A"
alias gc="git commit -m"
# alias gph="git push"
# alias gpl="git pull"
# alias gf="git fetch"
alias gd="git diff --color-words"
alias gl="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# A simpler, and probably more universal, alias returns you to the Git project’s top level. This alias is useful because when you’re working on a project, that project more or less becomes your "temporary home" directory. It should be as simple to go "home" as it is to go to your actual home, and here’s an alias to do it:
alias cg='cd `git rev-parse --show-toplevel`'


# Back Up [function, not alias] – Copy a file to the current directory with today’s date automatically appended to the end.
bu() { cp "$1" "$1".backup-`date +%y%m%d%H%M%S`; }

# Find a file from the current directory
alias ff='find . -name '

# shows the path variable
alias path='echo -e ${PATH//:/\n}'


extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar x $1       ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }


# Resume wget by default
alias wget="wget -c"

# alias bashrc='vim Dev/dotfiles/.bashrc && source Dev/dotfiles/.bashrc'

eval "$(starship init bash)"

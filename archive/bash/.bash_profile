if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
    . ~/.bash_aliases_mac
fi

if [ -d ~/bin ]; then
    PATH=$PATH:~/bin
fi

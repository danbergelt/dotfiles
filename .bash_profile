export PS1="\w :: "

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f ~/.bashlocal ]; then
    . ~/.bashlocal
fi

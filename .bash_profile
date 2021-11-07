export PS1="\w (\u) :: "

if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f ~/.bashlocal ]; then
    . ~/.bashlocal
fi

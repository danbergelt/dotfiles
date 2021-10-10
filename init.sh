#!/bin/bash

#
# Entrypoint
#

read -p "This may overwrite files in your home directory. Are you sure? (y/n) " -n 1;
if [[ $REPLY = "y" ]]; then
        echo
        # 1. Sync files
        rsync --exclude={"README.md","init.sh",".git/"} -avh --no-perms . ~
        # 2. Download vim plugin manager
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        # 3. Download all vim plugins
        vim +'PlugInstall --sync' +qall &> /dev/null
fi;

#!/bin/bash

#
# 1. Sync files
# 2. Install vim plugins
#

read -p "This may overwrite files in your home directory. Are you sure? (y/n) " -n 1;
if [[ $REPLY = "y" ]]; then
        echo
        rsync --exclude={"README.md","init.sh",".git/"} -avh --no-perms . ~
        vim +'PlugInstall --sync' +qall &> /dev/null
fi;

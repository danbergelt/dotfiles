#!/bin/sh


init() {
  rsync --exclude={"README.md","init.sh",".git/"} -avh --no-perms . ~
  vim +'PlugInstall --sync' +qall &> /dev/null
}


if [[ $1 = "-f" ]]; then
  echo
  init
else
  read -p "This may overwrite files in your home directory. Are you sure? (y/n) " -n 1;
  if [[ $REPLY = "y" ]]; then
    echo
    init
  fi;
fi;


unset init;

#!/bin/sh


init() {
  rsync \
    --exclude ".git/" \
    --exclude "README.md" \
    -avh --no-perms . ~;
}


if [[ $1 = "-f" ]]; then
  init
else
  read -p "This may ovewrite files in your home directory. Are you sure? (y/n) " -n 1;
  if [[ $REPLY = "y" ]]; then
    init
  fi;
fi;


unset init;

# Rebase N commits from the HEAD
rebase() {
  git rebase -i HEAD~"${1:-2}";
}

# Prompt styling
export PS1="\w\[\033[36m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ {\1}/')\[\033[00m\] :: "

export EDITOR="hx"
export GIT_EDITOR="hx"

alias hm="home-manager -f $HOME/dotfiles/home.nix"

[[ -s $HOME/.bashrc ]] && . $HOME/.bashrc
[[ -s $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh

# Rebase N commits from the HEAD
rebase() {
  git rebase -i HEAD~"${1:-2}";
}

alias hm="home-manager"

# Prompt styling
export PS1="\w\[\033[36m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ {\1}/')\[\033[00m\] :: "

export EDITOR="hx"
export GIT_EDITOR="hx"
export COLORTERM="truecolor"

BASHRC=~/.bashrc
NIXPRF=~/.nix-profile/etc/profile.d/nix.sh

[[ -s $BASHRC ]] && . $BASHRC
[[ -s $NIXPRF ]] && . $NIXPRF

# fzf bash bindings
if command -v fzf-share > /dev/null; then
  . "$(fzf-share)/key-bindings.bash"
  . "$(fzf-share)/completion.bash"
fi
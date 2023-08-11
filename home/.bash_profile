alias hm="home-manager"

# Prompt styling
export PS1="\w\[\033[36m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ {\1}/')\[\033[00m\] :: "

BASHRC=~/.bashrc
[[ -s $BASHRC ]] && . $BASHRC

NIXPRF=~/.nix-profile/etc/profile.d/nix.sh
[[ -s $NIXPRF ]] && . $NIXPRF

# fzf bash bindings
if command -v fzf-share > /dev/null; then
  . "$(fzf-share)/key-bindings.bash"
  . "$(fzf-share)/completion.bash"
fi

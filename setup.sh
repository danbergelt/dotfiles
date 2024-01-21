#!/usr/bin/env bash

set -euo pipefail

# Constants
PROFILE_PATH="$HOME/.config/home-manager/home.nix"
UPSTREAM="github.com/danbergelt/dotfiles.git"

# Default values
DEFAULT_REPO_LOCATION="$HOME/dotfiles"

# Inputs
FORCE=
GITHUB_TOKEN=
GIT_USERNAME=
GIT_EMAIL=
REPO_LOCATION="$DEFAULT_REPO_LOCATION"

usage() {
  cat <<-EOF

  Usage: setup.sh [options]

  Options:

    -h, --help                  Display usage information
    -f, --force                 Skip user confirmations
    --github-token=[token]      GitHub API token used when pushing config changes upstream
    --git-username=[username]   Git username used when pushing config changes upstream
    --git-email=[email]         Git email used when pushing config changes upstream
    --repo-location=[location]  Local repo location [default: $DEFAULT_REPO_LOCATION]
 
EOF
}

install_nix() {
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
}

clean() {
  rm -f "$PROFILE_PATH"
  rm -rf "$REPO_LOCATION" 
}

install_home_manager() {
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  home-manager init
}

clone_dotfiles_repo() (
  git clone "https://$UPSTREAM" "$REPO_LOCATION"
  cd "$REPO_LOCATION"

  if test -n "$GITHUB_TOKEN"; then
    git remote remove origin
    git remote add origin "https://$GITHUB_TOKEN@$UPSTREAM"
  fi

  if test -n "$GIT_USERNAME"; then
    git config user.name "$GIT_USERNAME"
  fi

  if test -n "$GIT_EMAIL"; then
    git config user.email "$GIT_EMAIL"
  fi
)

expose_dotfiles_config() {
  local import anchor

  target="enable = true;"
  import="imports = [$REPO_LOCATION/base.nix];"

  sed -i "s:$target:$target\n\n  $import:" "$PROFILE_PATH"
}

abort() {
  >&2 echo "[ERROR]: $1" && exit 1
}

assert_exists() {
  if ! command -v "$1" &> /dev/null; then
    abort "$1 is required"
  fi
}

get_user_confirmation() {
  if test -n "$FORCE"; then
    return
  fi

  read -p "Setup dotfiles from scratch? (y/n) " choice

  case "$choice" in
    y|Y) return ;;
    n|N) exit 0 ;;
    *) get_user_confirmation ;;
  esac
}

while test $# -ne 0; do
  case "$1" in
    -h|--help) usage && exit ;;
    -f|--force) FORCE="true" ;; 
    --github-token) shift; GITHUB_TOKEN="$1" ;;
    --git-username) shift; GIT_USERNAME="$1" ;;
    --git-email) shift; GIT_EMAIL="$1" ;;
    --repo-location) shift; REPO_LOCATION="$1" ;;
  esac
  shift
done

assert_exists "git"
assert_exists "curl"
get_user_confirmation
clean
install_nix  
install_home_manager
clone_dotfiles_repo
expose_dotfiles_config
home-manager switch
source ~/.bashrc
echo "SETUP COMPLETE"

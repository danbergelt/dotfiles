#!/usr/bin/env bash

set -euo pipefail

# Constants
PROFILE_PATH="$HOME/.config/home-manager/home.nix"
UPSTREAM="github.com/danbergelt/dotfiles.git"
REPO_LOCATION="$HOME/dotfiles"

# Inputs
FORCE=
GITHUB_TOKEN=
GIT_USERNAME=
GIT_EMAIL=

usage() {
  cat <<-EOF

  Usage: setup.sh [options]

  Options:

    -h, --help                  Display usage information
    -f, --force                 Skip user confirmations
    --github-token [token]      GitHub API token used when pushing config changes upstream
    --git-username [username]   Git username used when pushing config changes upstream
    --git-email [email]         Git email used when pushing config changes upstream
 
EOF
}

abort() {
  >&2 echo "[ERROR] $1" && exit 1
}

assert_exists() {
  if ! command -v "$1" &> /dev/null; then
    abort "$1 is required"
  fi
}

ask() {
  read -p "$1" choice
  case "$choice" in
    y|Y) return ;;
    n|N) exit 0 ;;
    *) ask "$1" ;;
  esac
}

while test $# -ne 0; do
  case "$1" in
    -h|--help) usage && exit ;;
    -f|--force) FORCE="true" ;; 
    --github-token) shift; GITHUB_TOKEN="$1" ;;
    --git-username) shift; GIT_USERNAME="$1" ;;
    --git-email) shift; GIT_EMAIL="$1" ;;
    *) usage && abort "Unrecognized argument: $1" ;;
  esac
  shift
done

assert_exists git
assert_exists curl

if test -z "$FORCE"; then
  ask "Setup dotfiles? (y/n) "
fi

# TODO: remove
rm -f "$PROFILE_PATH"

# Install nix and home-manager
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Hydrate the repo to match the upstream
if test -d "$REPO_LOCATION"; then
  pushd "$REPO_LOCATION"
  git fetch origin main
  git reset --hard origin/main
else
  git clone "https://$UPSTREAM" "$REPO_LOCATION"
  pushd "$REPO_LOCATION"
fi

# Configure the repo
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
popd

# TODO: do not write if already importing in the file
target="enable = true;"
import="imports = [$REPO_LOCATION];"
sed -i "s:$target:$target\n\n  $import:" "$PROFILE_PATH"

home-manager switch

echo "All done, please reload your shell"

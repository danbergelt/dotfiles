#!/usr/bin/env bash

set -euo pipefail

# Constants
PROFILE_PATH="$HOME/.config/home-manager/home.nix"
ORIGIN="github.com/danbergelt/dotfiles.git"
REPO_LOCATION="$HOME/dotfiles"
DEFAULT_NIX_IMPORT="imports = [$REPO_LOCATION];"

# Inputs
FORCE=
GITHUB_TOKEN=

usage() {
  cat <<-EOF

  Usage: setup.sh [options]

  Options:

    -h, --help              Display usage information
    -f, --force             Skip user confirmations
    --github-token <token>  GitHub API token used when pushing changes
 
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
  read -rp "$1 (y/n) " choice
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
    *) usage && abort "Unrecognized argument: $1" ;;
  esac
  shift
done

if test -z "$GITHUB_TOKEN"; then
  usage
  abort "Missing GitHub API token"
fi

assert_exists git
assert_exists curl

if test -z "$FORCE"; then
  ask "Bootstrap dotfiles?"
fi

# Cleanup
rm -rf "$REPO_LOCATION"
rm -f "$PROFILE_PATH"

# Install nix and home-manager
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Clone the dotfiles repo and apply the API token
git clone "https://$ORIGIN" "$REPO_LOCATION"
pushd "$REPO_LOCATION"
git remote remove origin
git remote add origin "https://$GITHUB_TOKEN@$ORIGIN"
popd

# Import the dotfiles config in the home-manager config
line="programs.home-manager.enable = true;"
replacement="$line\n\n  $DEFAULT_NIX_IMPORT"
sed -i "s:$line:$replacement:" "$PROFILE_PATH"

home-manager switch

echo "All done, please reload your shell"

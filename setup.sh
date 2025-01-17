#!/usr/bin/env bash

set -euo pipefail

# Constants
PROFILE_PATH="$HOME/.config/home-manager/home.nix"
ORIGIN="github.com/danbergelt/dotfiles.git"
REPO_LOCATION="$HOME/dotfiles"

# Inputs
FORCE=
TOKEN=

show_usage() {
  cat <<-EOF

  Usage: setup.sh [options] --token <token>

  Options:

    -h, --help           Display usage information
    -f, --force          Skip user confirmations
    -t, --token <token>  GitHub API token
 
EOF
}

abort() {
  >&2 echo "[ERROR] $1" && exit 1
}

ask() {
  read -rp "$1 (y/n) " choice
  case "$choice" in
    y|Y) return ;;
    n|N) exit 0 ;;
    *) ask "$1" ;;
  esac
}

# Nix cannot already exist. This script is for fresh installations
if command -v nix &> /dev/null; then
  abort "Nix is already installed on this machine. You \
must uninstall Nix before executing this setup script"
fi

# Parse input
while test $# -ne 0; do
  case "$1" in
    -h|--help) show_usage && exit ;;
    -f|--force) FORCE="true" ;; 
    -t|--token) shift; TOKEN="$1" ;;
    *) show_usage && abort "Unrecognized argument: $1" ;;
  esac
  shift
done

# Github token is required
if test -z "$TOKEN"; then
  show_usage
  abort "Missing GitHub API token"
fi

# Test that required commands exist
for cmd in git curl; do
  if ! command -v "$cmd" &> /dev/null; then
    abort "$cmd not found"
  fi
done

# Show a prompt to confirm the setup
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
git remote add origin "https://$TOKEN@$ORIGIN"
popd

# Patch the dotfiles config into the generated home-manager config
profile_line="programs.home-manager.enable = true;"
profile_line_replace="$profile_line\n\n  imports = [$REPO_LOCATION];"
sed -i "s:$profile_line:$profile_line_replace:" "$PROFILE_PATH"

home-manager switch

echo "All done, please reload your shell"

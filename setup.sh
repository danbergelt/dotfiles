#!/usr/bin/env bash

set -euo pipefail

# Constants
PROFILE_PATH="$HOME/.config/home-manager/home.nix"
ORIGIN="github.com/danbergelt/dotfiles.git"
REPO_LOCATION="$HOME/dotfiles"
DEFAULT_NIX_IMPORT="imports = [$REPO_LOCATION];"

# Inputs
FORCE=
NO_SYNC=
GITHUB_TOKEN=

usage() {
  cat <<-EOF

  Usage: setup.sh [options]

  Options:

    -h, --help                  Display usage information
    -f, --force                 Skip user confirmations
    --no-sync                   If already cloned, do not sync with the origin
    --github-token [token]      GitHub API token used when pushing changes
 
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
    --no-sync) NO_SYNC="true" ;;
    --github-token) shift; GITHUB_TOKEN="$1" ;;
    *) usage && abort "Unrecognized argument: $1" ;;
  esac
  shift
done

assert_exists git
assert_exists curl

if test -z "$FORCE"; then
  ask "Bootstrap dotfiles? (y/n) "
fi

# Install nix and home-manager
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

if test -d "$REPO_LOCATION"; then
  pushd "$REPO_LOCATION"

  # Hard sync w/ the origin unless otherwise
  # specified, skip this with --no-sync to
  # bootstrap against your local copy
  if test -z "$NO_SYNC"; then
    git fetch origin main
    git reset --hard origin/main
  fi
else
  git clone "https://$ORIGIN" "$REPO_LOCATION"
  pushd "$REPO_LOCATION"
fi

if test -n "$GITHUB_TOKEN"; then
  git remote remove origin
  git remote add origin "https://$GITHUB_TOKEN@$ORIGIN"
fi

popd

# Import the dotfiles config in the home-manager config,
# this is a little naive but works well enough for
# newly-generated home-manager config files
if ! grep -Fq "$DEFAULT_NIX_IMPORT" "$PROFILE_PATH"; then
  sed -i "\$s:}:  $DEFAULT_NIX_IMPORT\n}:" "$PROFILE_PATH"
fi

home-manager switch

echo "All done, please reload your shell"

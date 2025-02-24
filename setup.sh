#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail

# Constants
PROFILE_PATH="$HOME/.config/home-manager/home.nix"
ORIGIN="github.com/danbergelt/dotfiles.git"
REPO_LOCATION="$HOME/dotfiles"

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[1;34m"
NC="\033[0m"

# Inputs
FORCE=
TOKEN=

show_usage() {
  cat <<-EOF

  Usage: setup.sh [options]

  Options:

    -h, --help           Display usage information
    -f, --force          Skip user confirmations
    -t, --token [token]  GitHub API token
 
EOF
}

abort() {
  >&2 echo -e "${RED}[ERROR]${NC} $1" && exit 1
}

info() {
  echo -e "\n${BLUE}[INFO]${NC} $1"
}

ask() {
  read -rp "$1 (y/n) " choice
  case "$choice" in
    y|Y) return ;;
    n|N) exit 0 ;;
    *) ask "$1" ;;
  esac
}

# These commands must exist
for cmd in git curl; do
  if ! command -v "$cmd" &> /dev/null; then
    abort "$cmd missing in PATH"
  fi
done

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

if test -z "$FORCE"; then
  ask "Bootstrap dotfiles?"
fi

info "Cloning dotfiles repo"
if test -e "$REPO_LOCATION"; then
  echo "$REPO_LOCATION already exists"
else
  # A token is required to push changes upstream
  if test -z "$TOKEN"; then
    show_usage && abort "Missing GitHub API token"
  fi

  git clone "https://$ORIGIN" "$REPO_LOCATION"
  pushd "$REPO_LOCATION" > /dev/null
  git remote remove origin
  git remote add origin "https://$TOKEN@$ORIGIN"
  git config user.name "danbergelt"
  git config user.email "dan@danbergelt.com"
  popd > /dev/null
fi

info "Installing nix"
if command -v nix &> /dev/null; then
  echo "Nix is already installed"
else
  bash <(curl -L https://nixos.org/nix/install)
fi

source "$HOME/.nix-profile/etc/profile.d/nix.sh"

info "Installing home-manager"
if nix-channel --list | grep -q home-manager; then
  echo "Home-manager is already installed"
else
  hm="https://github.com/nix-community/home-manager/archive/master.tar.gz"
  nix-channel --add "$hm" home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
fi

# Inject dotfiles config into home-manager profile
imports="imports = [$REPO_LOCATION];"
if ! grep -q -F "$imports" "$PROFILE_PATH"; then
  anchor="programs.home-manager.enable = true;"
  header="# GENERATED BY DOTFILES SETUP SCRIPT"
  script="s:$anchor:$anchor\n\n  $header\n  $imports:"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$script" "$PROFILE_PATH"
  else
    sed -i "$script" "$PROFILE_PATH"
  fi
fi

info "Installing packages"
home-manager switch -b bak

echo -e "${GREEN}All done, please reload your shell${NC}\n"

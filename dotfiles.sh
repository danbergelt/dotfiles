#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail

# Constants
ORIGIN="github.com/danbergelt/dotfiles.git"
REPO_LOCATION="$HOME/dotfiles"

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[1;34m"
NC="\033[0m"

# Inputs
FORCE=
TOKEN=
CONFIG=

show_usage() {
  cat <<-EOF

  Usage: dotfiles.sh <command> [options]

  Commands:

    setup                Bootstrap dotfiles environment
    get-token            Print the current GitHub API token
    set-token <token>    Update the GitHub API token

  Options:

    -h, --help            Display usage information
    -f, --force           Skip user confirmations (setup only)
    -t, --token <token>   GitHub API token (setup only)
    -c, --config <name>   Flake config name: wsl, linux, mac (setup only)

EOF
}

abort() {
  >&2 echo -e "${RED}[ERROR]${NC} $1" && exit 1
}

info() {
  echo -e "\n${BLUE}[INFO]${NC} $1"
}

warn() {
  echo -e "\n${YELLOW}[WARN]${NC} $1"
}

ask() {
  read -rp "$1 (y/n) " choice
  case "$choice" in
    y|Y) return ;;
    n|N) exit 0 ;;
    *) ask "$1" ;;
  esac
}

# Get the current access token
get_token() {
  local url token

  url="$(git -C "$REPO_LOCATION" remote get-url origin 2>/dev/null)"
  # Get the value between 'https://' and '@' (should be the token)
  token="$(echo "$url" | awk -F 'https://|@' 'NF >= 3 {print $2}')"

  if test -n "$token"; then
    echo "$token"
  else
    return 1
  fi
}

# Set the access token
set_token() {
  local token

  token="$1"

  if test -z "$token"; then
    abort "No access token provided"
  fi

  git -C "$REPO_LOCATION" remote set-url origin "https://$token@$ORIGIN"
}

# Initialize dotfiles in an environment
setup() {
  if test -z "$FORCE"; then
    ask "Bootstrap dotfiles?"
  fi

  info "Cloning dotfiles repo"
  if test -e "$REPO_LOCATION"; then
    echo "$REPO_LOCATION already exists"
  else
    git clone "https://$ORIGIN" "$REPO_LOCATION"
    git -C "$REPO_LOCATION" config user.name "danbergelt"
    git -C "$REPO_LOCATION" config user.email "dan@danbergelt.com"
    # A token is required to push changes upstream
    if test -n "$TOKEN"; then
      set_token "$TOKEN"
    else
      warn "No token provided, push access will not be configured"
    fi
  fi

  info "Installing nix"
  if command -v nix &> /dev/null; then
    echo "Nix is already installed"
  else
    curl -L https://releases.nixos.org/nix/nix-2.31.2/install -o /tmp/nix-install
    bash /tmp/nix-install
  fi

  if ! test -f "$HOME/.nix-profile/etc/profile.d/nix.sh"; then
    abort "nix.sh file not found at expected location"
  fi

  source "$HOME/.nix-profile/etc/profile.d/nix.sh"

  info "Enabling flakes"
  if ! nix flake --help &> /dev/null; then
    mkdir -p "$HOME/.config/nix"
    echo "experimental-features = nix-command flakes" > "$HOME/.config/nix/nix.conf"
  else
    echo "Flakes already enabled"
  fi

  info "Installing packages"
  # Validate that a config was passed and exists in the home configurations
  local configs
  configs=$(nix eval "$REPO_LOCATION#homeConfigurations" --apply builtins.attrNames --json)
  if test -z "$CONFIG"; then
    abort "No config specified (expected one of: $configs)"
  elif ! echo "$configs" | grep -q "\"$CONFIG\""; then
    abort "Unknown config '$CONFIG' (expected one of: $configs)"
  fi
  # Do the initial switch and pin to the current config
  nix run home-manager -- switch --impure -b bak --flake "$REPO_LOCATION#$CONFIG"

  echo -e "${GREEN}All done, please reload your shell${NC}\n"
}

# These commands must exist
for cmd in git curl; do
  if ! command -v "$cmd" &> /dev/null; then
    abort "$cmd missing in PATH"
  fi
done

# Require a command
if test $# -eq 0; then
  show_usage
  abort "No command provided"
fi

COMMAND="$1"
shift

# Argument parsing
case "$COMMAND" in
  -h|--help)
    show_usage
    exit
    ;;

  get-token)
    if test $# -ne 0; then
      show_usage
      abort "get-token accepts no arguments"
    fi

    get_token
    exit $?
    ;;

  set-token)
    if test $# -eq 0; then
      show_usage
      abort "set-token requires a token argument"
    fi

    set_token "$1"
    exit
    ;;

  setup)
    while test $# -ne 0; do
      case "$1" in
        -f|--force)
          FORCE="true"
          ;;
        -t|--token)
          shift
          test $# -eq 0 && abort "--token requires a value"
          TOKEN="$1"
          ;;
        -c|--config)
          shift
          test $# -eq 0 && abort "--config requires a value"
          CONFIG="$1"
          ;;
        *)
          show_usage
          abort "setup: unrecognized option: $1" ;;
      esac
      shift
    done

    setup
    exit
    ;;

  *)
    show_usage
    abort "Unknown command: $COMMAND"
    ;;
esac

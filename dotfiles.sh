#!/usr/bin/env bash
# shellcheck disable=SC1091

set -euo pipefail

# Constants
ORIGIN="github.com/danbergelt/dotfiles.git"
REPO_LOCATION="$HOME/dotfiles" # Source of truth
LOCAL_FLAKE="$HOME/.dotfiles" # Host-only files

# Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[1;34m"
NC="\033[0m"

# Inputs
YES=
TOKEN=
CONFIG=
OVERWRITE=

show_usage() {
  cat <<-EOF

  Usage: dotfiles.sh <command> [options]

  Commands:

    setup                Bootstrap dotfiles environment
    get-token            Print the current GitHub API token
    set-token <token>    Update the GitHub API token

  Options:

    -h, --help            Display usage information
    -y, --yes             Skip user confirmations (setup only)
    -o, --overwrite       Regenerate local flake even if it exists (setup only)
    -t, --token <token>   GitHub API token (setup only)
    -c, --config <name>   Flake config name: wsl, linux, mac (setup only, auto-detected if omitted)

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

# Get list of valid platform values from the Nix configuration
get_valid_platforms() {
  nix eval "$REPO_LOCATION#platforms" --apply builtins.attrNames --json 2> /dev/null
}

# Generate the host-specific flake from the template
generate_local_flake() {
  mkdir -p "$LOCAL_FLAKE"

  local tmp
  tmp="$(mktemp)"

  sed -e "s|@PLATFORM@|$CONFIG|g" \
      -e "s|@USERNAME@|$USER|g" \
      -e "s|@HOME@|$HOME|g" \
      -e "s|@DOTFILES@|$REPO_LOCATION|g" \
      "$REPO_LOCATION/local.template.nix" > "$tmp"

  mv "$tmp" "$LOCAL_FLAKE/flake.nix"
}

# Derive the config from the environment
detect_config() {
  if test -n "${WSL_DISTRO_NAME:-}"; then
    echo "wsl"
  elif test "$(uname -s)" = "Darwin"; then
    echo "mac"
  elif test "$(uname -s)" = "Linux"; then
    echo "linux"
  fi
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
  CONFIG="${CONFIG:-$(detect_config)}"
  if ! get_valid_platforms | grep -q "\"$CONFIG\""; then
    abort "Unknown config '$CONFIG' (expected one of: $(get_valid_platforms))"
  fi

  if test -z "$YES"; then
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

  info "Generating local flake"
  if test -f "$LOCAL_FLAKE/flake.nix" && test -z "$OVERWRITE"; then
    echo "$LOCAL_FLAKE/flake.nix already exists"
  else
    generate_local_flake
  fi

  info "Installing packages"
  nix run home-manager -- switch -b bak --flake "$LOCAL_FLAKE"

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
        -y|--yes)
          YES="true"
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
        -o|--overwrite)
          OVERWRITE="true"
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

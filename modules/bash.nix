{ pkgs, ... }:

{
  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
      BAT_THEME = "base16";
    };

    shellAliases = {
      hms = "~/dotfiles/dotfiles.sh sync && home-manager switch --flake ~/.dotfiles";
      ncg = "nix-collect-garbage -d";
      gcb = "git branch | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -D";
    };

    initExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh
      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh

      __get_ps1() {
        local value nix_packages

        value="\w"

        # Track the current git branch
        value+="\[\e[01;36m\]\$(__git_ps1)\[\e[00m\] "

        nix_packages="$(
          printf '%s\n' "$PATH" \
            | tr ':' '\n' \
            | awk -F/ '/^\/nix\/store\// {
                name=$4
                sub(/^[a-z0-9]{32}-/, "", name)
                sub(/\.drv$/, "", name)
                sub(/-bin$/, "", name)
                print name
              }' \
            | sort -u \
            | paste -sd ',' -
        )"

        # Track packages injected by "nix shell"
        if [ -n "$nix_packages" ]; then
          value+="\[\e[01;35m\][$nix_packages]\[\e[00m\] "
        fi

        value+=":: "

        echo "$value"
      }

      PS1="$(__get_ps1)"

      # Activate Node from version manager
      XDG_RUNTIME_DIR=/tmp/run/user/$(id -u)
      mkdir -p "$XDG_RUNTIME_DIR"
      eval "$(fnm env --use-on-cd --shell bash)"

      ######### MUST BE LAST #########
      source ~/.overrides 2> /dev/null
    '';
  };
}

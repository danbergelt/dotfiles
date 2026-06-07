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
      hms = "home-manager switch --flake ~/.dotfiles";
      ncg = "nix-collect-garbage -d";
      gcb = "git branch | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -D";
    };

    initExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh

      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      git_state_indicator="\[\e[01;36m\]\$(__git_ps1)\[\e[00m\]"

      PS1="\w$git_state_indicator :: "

      # Activate Node from version manager
      XDG_RUNTIME_DIR=/tmp/run/user/$(id -u)
      mkdir -p "$XDG_RUNTIME_DIR"
      eval "$(fnm env --use-on-cd --shell bash)"

      ######### MUST BE LAST #########
      source ~/.overrides 2> /dev/null
    '';
  };
}

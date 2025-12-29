{ pkgs, ... }:

{
  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
      BAT_THEME = "base16";
      NIX_SHELL_PRESERVE_PROMPT = 1;
    };

    shellAliases = {
      hms = "home-manager switch";
      ncg = "nix-collect-garbage -d";
      ncu = "nix-channel --update";
      gcb =
        "git branch | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -D";
    };

    initExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh

      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      git_state_indicator="\[\e[01;36m\]\$(__git_ps1)\[\e[00m\]"

      # NOTE: this is only reliable for `nix-shell`, if at some point
      # I switch to using the experimental API, we'll have to find some
      # other way of determining whether we are inside of a nix shell
      nix_shell="$(test -n "$IN_NIX_SHELL" && echo "<''${name:-shell}> ")"
      nix_shell_indicator="\[\e[01;35m\]\$nix_shell\[\e[00m\]"

      PS1="$nix_shell_indicator\w$git_state_indicator :: "

      # Activate Node from version manager
      XDG_RUNTIME_DIR=/tmp/run/user/$(id -u)
      mkdir -p "$XDG_RUNTIME_DIR"
      eval "$(fnm env --use-on-cd --shell bash)"

      ######### MUST BE LAST #########
      source ~/.overrides 2> /dev/null
    '';
  };
}

{ pkgs, ... }:

{
  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
      ENTR_INOTIFY_WORKAROUND = 1;
      BAT_THEME = "Visual Studio Dark+";
    };

    shellAliases = {
      hms = "home-manager switch";
      ncg = "nix-collect-garbage -d";
      ncu = "nix-channel --update";
    };

    initExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh

      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      PS1="\w\[\e[01;36m\]\$(__git_ps1)\[\e[00m\] :: "

      # Open a Nix shell for the provided program
      shell() {
        if test -z "$1"; then
          echo "Usage: shell <program>"
          return 1
        fi

        # Place custom shells in ~/shells
        program="$HOME/shells/$1.nix"

        # Pass through to Nix package if no shell file found
        if ! test -f "$program"; then
          program="-p $1"
        fi

        NIX_PKGS_ALLOW_INSECURE=1 nix-shell --pure "$program"
      }

      # Activate Node from version manager
      eval "$(fnm env --use-on-cd --shell bash)"

      ######### MUST BE LAST #########
      source ~/.overrides 2> /dev/null
    '';
  };

}

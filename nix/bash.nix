{ pkgs, ... }:

{
  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
      ENTR_INOTIFY_WORKAROUND = 1;
      BAT_THEME = "base16";
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

      # Activate Node from version manager
      eval "$(fnm env --use-on-cd --shell bash)"

      ######### MUST BE LAST #########
      source ~/.overrides 2> /dev/null
    '';
  };

}

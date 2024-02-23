{ pkgs, ... }:

{
  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
      ENTR_INOTIFY_WORKAROUND = 1;
    };

    shellAliases = {
      hms = "home-manager switch";
    };

    initExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh
      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      PS1="\w\[\e[01;36m\]\$(__git_ps1)\[\e[00m\] :: "
      grm() { echo "$1" | entr -c vale "$1"; } # Grammar checker
      mdv() { echo "$1" | entr -cr glow "$1"; } # Markdown viewer
      source ~/.overrides 2> /dev/null # MUST BE LAST
    '';
  };

}

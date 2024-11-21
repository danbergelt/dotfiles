{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    jq
    git
    curl
    tealdeer
    bat
    entr
    go
    fnm # Node version manager
    python310
  ];
}

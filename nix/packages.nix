{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    shellcheck
    jq
    git
    curl
    tealdeer
    bat
    tree
    go
    fnm # Node version manager
    uv # Python version manager
  ];
}

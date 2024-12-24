{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    jq
    git
    curl
    tealdeer
    bat
    go
    fnm # Node version manager
    uv # Python version manager
  ];
}

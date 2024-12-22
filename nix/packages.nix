{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    jq
    git
    curl
    tealdeer
    hyperfine
    bat
    entr
    go
    fnm # Node version manager
    uv # Python version manager
  ];
}

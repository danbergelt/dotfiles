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
    nodejs_22
    python310
  ];
}

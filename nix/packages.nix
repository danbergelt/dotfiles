{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    jq
    git
    curl
    glow
    entr
    vale
    go
    nodejs
    python3
  ];
}

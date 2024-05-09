{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    jq
    git
    curl
    tealdeer
    glow
    go
    nodejs
    python310
  ];
}

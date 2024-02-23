{ pkgs, ... }:

{
  home.packages = with pkgs; [
    shellcheck
    sqlfluff
    ripgrep
    jq
    git
    curl
    glow
    entr
    vale
    go
    nodejs
    nodePackages.typescript
    python3
    python3Packages.pip
  ];
}

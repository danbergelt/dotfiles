{ config, pkgs, ... }:

# https://lazamar.co.uk/nix-versions/ to generate archives (useful for pinning old package versions)
let
  archive = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
  }) {};
in

{
  home.packages = with pkgs; [
    # general
    tmux
    ripgrep
    fzf

    # python
    python3
    python3Packages.pip
    python3Packages.python-lsp-server

    # js
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server

    # go
    go
    gopls
  ];

  home.file = {
    ".hushlogin".text = "";
    ".tmux.conf".source = home/tmux.conf;
    ".bash_profile".source = home/bash_profile;
  };

  programs.helix = {
    enable = true;

    # NOTE: pinning due to https://github.com/helix-editor/helix/issues/7905
    package = archive.helix;
    
    settings = {
      theme = "dark_plus";
      editor = {
        auto-format = false;
        color-modes = true;
        bufferline = "multiple";
        line-number = "relative";
      };
    };
  };
}

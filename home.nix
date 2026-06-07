{ pkgs, cfg, ... }:

{
  imports = [
    modules/bash.nix
    modules/fzf.nix
    modules/tmux.nix
    modules/helix.nix
    modules/rust.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;

  home = {
    username = cfg.username;
    homeDirectory = cfg.homeDirectory;
    stateVersion = "24.11";

    packages =
      with pkgs;
      [
        just
        ripgrep
        shellcheck
        jq
        git
        curl
        tealdeer
        bat
        tree
        file
        go
        fnm
        uv
      ]
      ++ pkgs.lib.optionals (pkgs.stdenv.isLinux && !cfg.isWsl) [ xclip ];
  };
}

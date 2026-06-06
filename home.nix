{ pkgs, ... }:

let
  local = builtins.getEnv "HOME" + "/.local.nix";

in
{
  imports = [
    modules/bash.nix
    modules/fzf.nix
    modules/tmux.nix
    modules/helix.nix
    modules/rust.nix
  ]
  ++ (if builtins.pathExists local then [ local ] else [ ]);

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "24.11";

    packages = with pkgs; [
      just
      ripgrep
      shellcheck
      jq
      git
      curl
      tealdeer
      bat
      tree
      go
      fnm
      uv
    ];
  };
}

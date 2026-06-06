{ pkgs, ... }:

let local = ~/.local.nix;

in {
  imports = [
    nix/bash.nix
    nix/fzf.nix
    nix/tmux.nix
    nix/helix.nix
    nix/rust.nix
  ] ++ (if builtins.pathExists local then [ local ] else []);

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
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

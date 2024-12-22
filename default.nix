{ stdenv, ... }:

{
  imports = [
    nix/packages.nix
    nix/bash.nix
    nix/fzf.nix
    nix/tmux.nix
    nix/helix.nix
  ];

  _module.args = {
    utils = rec {
      isWSL = builtins.getEnv "WSL_DISTRO_NAME" != "";

      clipboard =
        if isWSL then
          "clip.exe"
        else if stdenv.isDarwin then
          "pbcopy"
        else if stdenv.isLinux then
          "xclip -selection clipboard"
        else
          abort "Unknown clipboard";
    };
  };
}

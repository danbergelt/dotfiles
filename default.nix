{ stdenv, ... }:

{
  imports = [
    nix/packages.nix
    nix/bash.nix
    nix/fzf.nix
    nix/tmux.nix
    nix/helix.nix
    nix/rust.nix
  ];

  _module.args = {
    # Extra utils
    my = rec {
      # Check if we are running inside of WSL or not
      isWSL = builtins.getEnv "WSL_DISTRO_NAME" != "";

      # Derive system clipboard based on environment
      clipboard = if isWSL then
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

{ stdenv, lib, ... }:

{
  imports = [
    nix/packages.nix
    nix/bash.nix
    nix/fzf.nix
    nix/tmux.nix
    nix/helix.nix
    nix/vale.nix
  ];

  _module.args = {
    # Expose some extra utils to the imported modules
    my = rec {
      # Check if we are running inside of WSL or not
      isWSL = builtins.getEnv "WSL_DISTRO_NAME" != "";

      # Derive system clipboard based on environment
      clipboard =
        if isWSL then
          "clip.exe"
        else if stdenv.isDarwin then
          "pbcopy"
        else if stdenv.isLinux then
          "xclip -selection clipboard"
        else
          abort "Unknown clipboard";

      # Run a command when switching
      mkHook = lib.hm.dag.entryAfter ["installPackages"];
    };

  };
}

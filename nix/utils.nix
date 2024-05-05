{ pkgs, lib }:

let
  # Check if running in WSL
  isWSL = builtins.pathExists /proc/sys/fs/binfmt_misc/WSLInterop;

  # System clipboard, derived from the current environment
  clipboard =
    if isWSL then
      "clip.exe"
    else if pkgs.stdenv.isDarwin then
      "pbcopy"
    else if pkgs.stdenv.isLinux then
      "xclip -selection clipboard"
    else
      abort "Unknown clipboard";
in

{ inherit isWSL clipboard; }

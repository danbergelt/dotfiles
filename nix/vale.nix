{ pkgs, lib, ... }:

let
  utils = import ./utils.nix { inherit pkgs lib; };
in

{
  # Create an "ignore" directory. You can add an "ignore.txt" file here,
  # containing words/jargon that you wish to ignore when spellchecking
  #
  # See https://vale.sh/docs/topics/styles/#ignoring-non-dictionary-words
  xdg.dataFile."vale/styles/config/ignore/.keep".text = "";

  home.file.".vale.ini".text = ''
    MinAlertLevel = warning
    Packages = Microsoft, proselint

    [*]
    BasedOnStyles = Vale, Microsoft, proselint
  '';

  home.activation.valeSync = utils.mkHook "${pkgs.vale}/bin/vale sync";
}

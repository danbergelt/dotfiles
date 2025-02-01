{ pkgs, lib, ... }:

{
  home.packages = [pkgs.vale];

  # Config file
  home.file.".vale.ini".text = ''
    MinAlertLevel = suggestion
    Packages = Microsoft
    Vocab = Global

    [*]
    BasedOnStyles = Vale, Microsoft

    # Overrides
    Microsoft.HeadingAcronyms = NO
    Microsoft.Acronyms = NO
  '';

  # Install + sync in one step
  home.activation.valeSync =
    lib.hm.dag.entryAfter ["installPackages"] "${pkgs.vale}/bin/vale sync";  
}

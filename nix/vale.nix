{ pkgs, my, ... }:

let
  stylesPath = ".vale/styles";
  vocabPath = "$HOME/${stylesPath}/config/vocabularies/Global";
in

{
  home.packages = [pkgs.vale];

  # Config file
  home.file.".vale.ini".text = ''
    StylesPath = ${stylesPath}
    MinAlertLevel = suggestion
    Packages = Microsoft
    Vocab = Global

    [*]
    BasedOnStyles = Vale, Microsoft

    # Overrides
    Microsoft.HeadingAcronyms = NO
    Microsoft.Acronyms = NO
  '';

  # Sync on every install
  home.activation.valeSync = my.mkHook "${pkgs.vale}/bin/vale sync";

  # Ensure global vocab path exists
  home.activation.valeMkVocab = my.mkHook "mkdir -p ${vocabPath}";

  # Expose accept/reject file paths
  home.sessionVariables = {
    VOCAB_ACCEPT_FILE="${vocabPath}/accept.txt";
    VOCAB_REJECT_FILE="${vocabPath}/reject.txt";
  };
}

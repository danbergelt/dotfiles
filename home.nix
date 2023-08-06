{ config, pkgs, ... }:

{
  # NOTE: these might need to be changed on new machines
  home.username = "dan";
  home.homeDirectory = "/home/dan";

  # NOTE: do not change!
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    # general executables
    tmux
    ripgrep
    fzf
        
    # python
    python310
    python310Packages.pip
    python310Packages.mypy
    python310Packages.python-lsp-server

    # js
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted

    # go
    go
    gopls
  ];

  home.file = {
    ".hushlogin".text = "";

    ".tmux.conf".source = cfg/.tmux.conf;
    ".bash_profile".source = cfg/.bash_profile;
  };

  programs.home-manager.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "dark_plus";
      editor = {
        line-number = "relative";
        lsp = {
          display-messages = true;
        };
      };
    };
  };
}

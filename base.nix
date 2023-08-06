{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # general
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
    ".tmux.conf".source = home/.tmux.conf;
    ".bash_profile".source = home/.bash_profile;
  };

  programs.home-manager.enable = true;

  programs.helix = {
    enable = true;
    settings = {
      theme = "dark_plus";
      editor = {
        auto-format = false;
        color-modes = true;
        bufferline = "multiple";
        line-number = "relative";
      };
    };
  };
}

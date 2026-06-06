{ pkgs, ... }:

let
  # 25.01
  pinned = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/de0fe301211c267807afd11b12613f5511ff7433.tar.gz";
    sha256 = "0lw17azfdh3gmh75ddha01j4c7fn38nz4w3jwzbaz0ngb8nchb3a";
  }) { inherit (pkgs) system; };
in

{
  programs.helix = {
    enable = true;
    package = pinned.helix;

    extraPackages = with pkgs; [
      nil
      gopls
      harper
      pyright
      nodePackages.typescript
      nodePackages.typescript-language-server
    ];

    settings = {
      theme = "base16_transparent";

      editor = {
        auto-format = false;
        color-modes = true;
        bufferline = "multiple";
        line-number = "relative";
        rulers = [ 120 ];
      };

      keys.normal.X = "select_line_above";
    };

    languages = {
      language-server = {
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
          config = { }; # REQUIRED
        };

        harper = {
          command = "harper-ls";
          args = [ "--stdio" ];
        };
      };

      language = [
        {
          name = "python";
          language-servers = [{ name = "pyright"; }];
        }
        {
          name = "markdown";
          language-servers = [{ name = "harper"; }];
        }
      ];
    };
  };
}

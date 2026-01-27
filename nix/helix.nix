{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

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

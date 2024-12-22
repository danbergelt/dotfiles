{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      nil
      gopls
      pyright
      harper
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
        rulers = [ 100 ];
      };
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
          name = "markdown";
          language-servers = [ { name = "harper"; } ];
        }
        {
          name = "python";
          language-servers = [ { name = "pyright"; } ];
        }
      ];
    };
  };
}

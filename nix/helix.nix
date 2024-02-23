{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      nil
      gopls
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.pyright
    ];

    settings = {
      theme = "dark_plus";
      editor = {
        auto-format = false;
        color-modes = true;
        bufferline = "multiple";
        line-number = "relative";
        rulers = [100];
      };
    };

    languages = {
      language-server = {
        pyright = {
          command = "pyright-langserver";
          args = ["--stdio"];
          config = {}; # REQUIRED
        };
      };

      language = [
        {
          name = "python";
          language-servers = [
            {
              name = "pyright";
            }
          ];
        }
      ];
    };
  };
}

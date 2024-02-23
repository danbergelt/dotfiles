{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      nil
      nodePackages.typescript-language-server
      nodePackages.pyright
      gopls
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

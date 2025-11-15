{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      nil
      gopls
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
    };

    languages = {
      language-server = {
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
          config = { }; # REQUIRED
        };
      };

      language = [
        {
          name = "python";
          language-servers = [ { name = "pyright"; } ];
        }
      ];
    };
  };
}

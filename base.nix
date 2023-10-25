{ pkgs, ... }:

let
  clipboard =
    if builtins.pathExists /proc/sys/fs/binfmt_misc/WSLInterop then
      "clip.exe"
    else
      abort "Could not derive system clipboard";
in

{
  home.packages = with pkgs; [
    # general
    shellcheck
    ripgrep
    jq
    git

    # js
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server

    # python
    python3
    python3Packages.pip
    nodePackages.pyright

    # go
    go
    gopls
  ];

  programs.bash = {
    enable = true;

    sessionVariables = {
      EDITOR = "hx";
      GIT_EDITOR = "hx";
      COLORTERM = "truecolor";
    };

    shellAliases = {
      hm = "home-manager";
    };

    initExtra = ''
      source ~/.nix-profile/etc/profile.d/nix.sh
      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      PS1="\w\[\e[01;36m\]\$(__git_ps1)\[\e[00m\] :: "
      source ~/.overrides 2> /dev/null
    '';
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.tmux = {
    enable = true;

    historyLimit = 5000;
    terminal = "screen-256color";
    keyMode = "vi";

    extraConfig = ''
      set -g mouse on
      set -g pane-active-border-style fg=green
      set -g status-right '%I:%M %p - %A, %b %d, %Y'
      
      bind c new-window -c '#{pane_current_path}'
      bind x split-window -h -c '#{pane_current_path}'
      bind y split-window -c '#{pane_current_path}'
      
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      bind R respawn-pane -k -c '#{pane_current_path}'
      
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel '${clipboard}'
      bind -T copy-mode-vi Enter send -X cancel
    '';
  };

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

    languages = {
      language = [
        {
          name = "python";
          language-server = {
            command = "pyright-langserver";
            args = ["--stdio"];
          };
          config = {}; # REQUIRED
        }
      ];
    };
  };
}

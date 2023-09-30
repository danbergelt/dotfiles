{ config, pkgs, ... }:

let
  clipboard =
    if builtins.pathExists /mnt/c then
      "clip.exe" # WSL
    else
      abort "Could not derive system clipboard";

  # https://lazamar.co.uk/nix-versions/ to generate archives of old nixpkgs versions
  archives = {
    # 03/11/2023 - pinning due to https://github.com/helix-editor/helix/issues/7905
    # When https://github.com/NixOS/nixpkgs/pull/249414 is merged, should be able to just use stable
    helix = (import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
    }) {}).helix;
  };
in

{
  home.packages = with pkgs; [
    # general
    shellcheck
    ripgrep
    fzf
    jq

    # python
    python3
    python3Packages.pip
    python3Packages.python-lsp-server

    # js
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server

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
      source ~/.nix-profile/etc/profile.d/nix.sh 2> /dev/null

      PS1="\w\[\033[36m\]\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ {\1}/')\[\033[00m\] :: "

      if command -v fzf-share > /dev/null; then
        . "$(fzf-share)/key-bindings.bash"
        . "$(fzf-share)/completion.bash"
      fi

      source ~/.local_overrides 2> /dev/null
    '';
  };

  programs.tmux = {
    enable = true;

    historyLimit = 5000;
    terminal = "screen-256color";
    keyMode = "vi";

    extraConfig = ''
      set -g mouse on
      set -g pane-active-border-style fg=green
      set -g status-right '%A, %d %b %Y %I:%M %p'
      
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

    package = archives.helix;
    
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

{ pkgs, lib, ... }:

let
  utils = import ./utils.nix { inherit pkgs lib; };
in

{
  programs.tmux = {
    enable = true;

    historyLimit = 5000;
    terminal = "screen-256color";
    keyMode = "vi";

    extraConfig = ''
      set -g mouse on
      set -g pane-active-border-style fg=green
      set -g status-right '%I:%M %p - %A, %b %d %Y'
      
      bind c new-window -c '#{pane_current_path}'
      bind x split-window -h -c '#{pane_current_path}'
      bind y split-window -c '#{pane_current_path}'
      
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n S-Left resize-pane -L 10
      bind -n S-Right resize-pane -R 10
      bind -n S-Up resize-pane -U 10
      bind -n S-Down resize-pane -D 10
      
      bind R respawn-pane -k -c '#{pane_current_path}'
      
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel '${utils.clipboard}'
      bind -T copy-mode-vi Enter send -X cancel
    '';
  };
}

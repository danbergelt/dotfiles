{ stdenv, ... }:

let
  clipboard =
    if builtins.pathExists /proc/sys/fs/binfmt_misc/WSLInterop then
      "clip.exe"
    else if stdenv.isDarwin then
      "pbcopy"
    else if stdenv.isLinux then
      "xclip -selection clipboard"
    else
      abort "Unknown clipboard";
in

{
  programs.tmux = {
    enable = true;

    historyLimit = 5000;
    terminal = "screen-256color";
    keyMode = "vi";

    extraConfig = ''
      set -g mouse on
      set -g escape-time 10
      set -g pane-active-border-style fg=green
      set -g status-right '%I:%M %p - %A, %b %d %Y'

      bind c new-window -c '#{pane_current_path}'
      bind x split-window -h -c '#{pane_current_path}'
      bind y split-window -c '#{pane_current_path}'

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L 10
      bind -r J resize-pane -D 10
      bind -r K resize-pane -U 10
      bind -r L resize-pane -R 10

      bind R respawn-pane -k -c '#{pane_current_path}'

      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel '${clipboard}'
      bind -T copy-mode-vi Enter send -X cancel
    '';
  };
}

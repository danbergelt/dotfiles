#
# Launch 4 tmux tiles
#

tiles() {
    tmux new-window \
        \; split-window \
        \; split-window \
        \; split-window \
        \; select-layout tiled \
        \; select-pane -t 0
}

#
# Navigate to a directory
#

d() {
    cd `find ~/me \( -name node_modules -o -name .git \) -prune -o -name "*" -type d -print | fzf`
}

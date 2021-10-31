#
# Aliases
#

alias tkw='tmux kill-window'

#
# Words to live by
#

zen() {
cat << EOF

    1. Be creative. Be curious. Question everything.
    2. Chunk problems into smaller problems. Small enough? Do it again.
    3. Write down what you're trying to accomplish, in plain English.
    4. Reuse other people's code - but you better understand it.
    5. Don't fall for the hype.
    6. Reject complexity.
    7. Avoid coupling unrelated components.
    8. Flat over nested, embrace pattern matching.
    9. Data structures, small & simple functions.
    10. DSLs are fantastic. Accidental DSLs are disasters.
    11. There are no silver bullets - it's always a tradeoff.

EOF
}

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

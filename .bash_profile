# Prompt styling
export PS1="\w :: "

# Launch 1 - 4 tmux panes, format and switch to 0th pane
p() {
    if [ -z $TMUX ]; then
        echo "Must be inside tmux"; return
    fi

    if [ -z $1 ] || [ $1 -le 0 ] || [ $1 -ge 5 ]; then
        echo "Usage: panes [1-4]"; return
    fi

    for _ in `seq 1 $1`; do
        tmux split-window
    done

    tmux select-layout tiled
    tmux select-pane -t 0
}

# Kill all non-attached tmux sessions
tks() {
    tmux ls \
        | awk 'BEGIN {FS=":"} !/(attached)/ {print $1}' \
        | xargs -I {} tmux kill-session -t {}
}

# Show all dirs or files in the provided path
show() {
    if [[ $1 != "d" ]] && [[ $1 != "f" ]] || [ -z $2 ]; then
        echo "Usage: show [d | f] path"; return
    fi

    local -r IGNORE="-name node_modules -o -name .git"

    find $2 \( $IGNORE \) -prune -o -type $1
}

# Navigate to a dir or open a file in ~/me via fzf
to() {
    case "$1" in
        d)
            local -r DIR=`show $1 ~/me | fzf`
            [[ -n $DIR ]] && cd $DIR ;;
        f)
            local -r FIL=`show $1 ~/me | fzf --preview 'head -$LINES {}'`
            [[ -n $FIL ]] && vim $FIL ;;
        *)
            echo "Usage: to [d | f]" ;;
    esac
}

# Find and kill a process
kp() {
    local -r PID=`ps -ef | fzf | awk '{print $2}'`
    [[ -n $PID ]] && kill -9 $PID
}

# Typecheck all changed JS files in current repo
tscjs() {
    local -r TSC_FLAGS="--noEmit --strict --allowJs --checkJs"

    git status --porcelain \
        | sed s/^...// \
        | grep '.js$' \
        | xargs tsc $TSC_FLAGS
}

# Run ctags from the repo root
tag() {
    local -r LOC=`pwd`
    cd `git rev-parse --show-toplevel`
    ctags -R .
    cd $LOC
}

# Aliases
alias d='to d'
alias f='to f'

# Source the .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

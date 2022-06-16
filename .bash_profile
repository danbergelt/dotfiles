# Prompt styling
export PS1="\w :: "

# One tmux pane
tp() {
    if [ -z $TMUX ]; then
        tmux; return
    fi

    tmux split-window \
        \; select-layout tiled \
        \; select-pane -t 0
}

# Show dirs or files in a path
show() {
    if [[ $1 != "d" ]] && [[ $1 != "f" ]] || [ -z $2 ]; then
        echo "Usage: show [d | f] path"; return
    fi

    local -r IGNORE="-name node_modules -o -name .git"

    find $2 \( $IGNORE \) -prune -o -type $1
}

# To directory in ~/me
td() {
    local -r D=`show d ~/me | fzf`
    [[ -n $D ]] && cd $D
}

# To file in ~/me
tf() {
    local -r F=`show f ~/me | fzf --preview 'head -$LINES {}'`
    [[ -n $F ]] && vim $F
}

# Find and kill process
kp() {
    local -r PID=`ps -ef | fzf | awk '{print $2}'`
    [[ -n $PID ]] && kill -9 $PID
}

# Typecheck changed JS in repo
tscjs() {
    local -r TSC_FLAGS="--noEmit --strict --allowJs --checkJs"

    git status --porcelain \
        | sed s/^...// \
        | grep '.js$' \
        | xargs tsc $TSC_FLAGS
}

# Run ctags in repo root
tag() {
    local -r LOC=`pwd`
    cd `git rev-parse --show-toplevel`
    ctags -R .
    cd $LOC
}

# Source the .bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

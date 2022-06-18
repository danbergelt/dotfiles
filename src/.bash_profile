# Prompt styling
export PS1="\w :: "

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

# To repo root
tr() {
    cd `git rev-parse --show-toplevel`
}

# Find and kill process
kp() {
    local -r PID=`ps -ef | fzf | awk '{print $2}'`
    [[ -n $PID ]] && kill -9 $PID
}

# Create a tsconfig.json file in the project root
ts() {
    cat ~/tsconfig.json > "`git rev-parse --show-toplevel`/tsconfig.json"
}

# Source fzf key bindings
if [ -f /usr/local/opt/fzf/shell/key-bindings.bash ]; then
    . /usr/local/opt/fzf/shell/key-bindings.bash
fi

# Source the .bashrc
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

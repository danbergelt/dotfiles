# Find and kill process by port
kport(){
    kill -9 "$(lsof -ti:"$1")" 2> /dev/null
}

# Render pretty markdown
markdown() {
    glow "$1" -s dark | less -r
}

# View scratch file
scratch() {
    if [[ ! -f ~/scratch.md ]]; then
        echo "Missing ~/scratch.md"
        exit 1
    fi

    markdown ~/scratch.md
}

# Dotfiles alias
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Use neovim
alias vim="nvim"

# Construct PATH
export PATH=$PATH:$HOME/.local/bin:~/bin/lua-lsp/bin

# Prompt styling
__parse_git_branch__() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ {\1}/'
}

export PS1="\w\[\033[36m\]\$(__parse_git_branch__)\[\033[00m\] :: "

# Source the .bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

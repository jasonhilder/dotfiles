# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Enable bash syntax highlighting
if [[ -f ~/.bash-syntax-highlighting/bash-syntax-highlighting.sh ]]; then
    source ~/.bash-syntax-highlighting/bash-syntax-highlighting.sh
fi

# Enable bash completion if available
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Case-insensitive completion
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "TAB:menu-complete"

# ------------------------
# HISTORY SETTINGS
# ------------------------
# Allow multi-line history
shopt -s cmdhist

# Avoid duplicates & unnecessary lines
HISTCONTROL=ignoredups:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Append to history instead of overwriting
shopt -s histappend

# Update history after each command
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ------------------------
# PROMPT
# ------------------------
# Color definitions
RESET='\[\033[0m\]'
BOLD='\[\033[1m\]'
RED='\[\033[31m\]'
GREEN='\[\033[32m\]'
YELLOW='\[\033[33m\]'
BLUE='\[\033[34m\]'
CYAN='\[\033[36m\]'
MAGENTA='\[\033[35m\]'

exit_code_status='$(exit_code=$?; [[ $exit_code -ne 0 ]] && echo -e " \[\033[1;31m\](exit $exit_code)\[\033[0m\]")'

# Git branch function
parse_git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo " ($branch)"
    fi
}


# Custom prompt
# PS1="${BOLD}${BLUE}\u@\h ${CYAN}\w${YELLOW}\$(parse_git_branch)${RESET}\n\$ "
PS1="${BOLD}${BLUE}\u@\h ${CYAN}\w${YELLOW}\$(parse_git_branch)${exit_code_status}${RESET}\n\$ "

# ------------------------
# GLOBALS
# ------------------------
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export TERM="xterm-256color"
export DEBUG=1

# ------------------------
# PATHS
# ------------------------
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/apps/nvim/bin:$PATH"

# FZF
export FZF_DEFAULT_COMMAND='fd --exclude={.git,.cache,.xmake,.zig-cache,build,tmp} --type f -H'

# GOLANG
export GOPATH="$HOME/.go"
export GOCACHE="$HOME/.go/cache"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/.go/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

# PHP
export PATH="$HOME/.phpenv/bin:$PATH"
export PATH="$HOME/.phpenv/shims:$PATH"

# Odin (uncomment if needed)
# export PATH="$HOME/.local/share/odin-lang:$PATH"

# Aseprite
export PATH="$HOME/.local/applications/aseprite:$PATH"

# ------------------------
# ALIASES
# ------------------------
alias ..='cd ..'
alias :q='exit'
alias dotfiles='cd ~/.dotfiles && vim'
alias wiki='cd ~/github/reimagined_barnacle && vim'
alias vim='nvim'
alias rmdir='safe_delete'
alias ll='ls -lah --color=auto'

# ------------------------
# FUNCTIONS
# ------------------------

# Project picker (pp)
pp() {
    if [ $# -ge 1 ]; then
        bash proj-select "$1"
    else
        dir=$(bash project-picker)
        if [ -n "$dir" ]; then
            cd "$dir" || return
        fi
    fi
}

# Fuzzy change directory
fcd() {
    dir=$(find . -type d -not -path '*/\.*' | fzf)
    [ -n "$dir" ] && cd "$dir"
}
alias cdd=fcd

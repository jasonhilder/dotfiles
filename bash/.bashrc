# ~/.bashrc - Enhanced Bash Configuration
# ==============================================================================
# Exit if not running interactively
[[ $- != *i* ]] && return

# ==============================================================================
# SYSTEM INTEGRATION
# ==============================================================================

# Source global definitions
[[ -f /etc/bashrc ]] && source /etc/bashrc
[[ -f /etc/bash.bashrc ]] && source /etc/bash.bashrc

# Enable programmable completion features
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    fi
fi

# ==============================================================================
# SHELL OPTIONS & BEHAVIOR
# ==============================================================================

# History settings
shopt -s histappend          # Append to history, don't overwrite
shopt -s cmdhist            # Store multi-line commands as one entry
shopt -s checkwinsize       # Update LINES and COLUMNS after each command
shopt -s cdspell            # Correct minor spelling errors in cd
shopt -s dirspell           # Correct spelling errors in directory names
shopt -s expand_aliases     # Expand aliases
shopt -s globstar           # Enable ** for recursive globbing
shopt -s nocaseglob         # Case-insensitive globbing

# Completion settings
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind "TAB:menu-complete"
bind "set colored-stats on"
bind "set visible-stats on"
bind "set mark-symlinked-directories on"

# ==============================================================================
# HISTORY CONFIGURATION
# ==============================================================================

export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="ls:ll:la:cd:cd -:pwd:exit:date:clear:history:* --help:bg:fg:jobs"
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================

# Core settings
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"
export BROWSER="firefox"
export TERM="xterm-256color"
export COLORTERM="truecolor"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Development
export DEBUG=1
export GOPATH="$HOME/.go"
export GOCACHE="$HOME/.go/cache"

# FZF configuration
export FZF_DEFAULT_COMMAND='fd --exclude={.git,.cache,.xmake,.zig-cache,build,tmp,node_modules,elpa} --type f -H'
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --preview-window=down:30%
    --bind 'ctrl-d:preview-page-down,ctrl-u:preview-page-up'
    --color=fg:#ffffff,header:#f38ba8,info:#cba6ac,pointer:#f5e0dc
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6ac,hl+:#f38ba8"

# ==============================================================================
# PATH CONFIGURATION
# ==============================================================================

# Function to safely add to PATH
add_to_path() {
    [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"
}

# User binaries
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"
add_to_path "/usr/local/bin"

# Development tools
add_to_path "$HOME/.local/apps/nvim/bin"
add_to_path "/usr/local/go/bin"
add_to_path "$HOME/.go/bin"
add_to_path "$GOPATH/bin"
add_to_path "$HOME/.cargo/bin"
add_to_path "$HOME/.npm-global/bin"

export PATH

# ==============================================================================
# COLORS & PROMPT
# ==============================================================================

# Color definitions for prompts (with \[\] escapes)
readonly RESET='\[\033[0m\]'
readonly BOLD='\[\033[1m\]'
readonly DIM='\[\033[2m\]'

# Basic colors
readonly RED='\[\033[31m\]'
readonly GREEN='\[\033[32m\]'
readonly YELLOW='\[\033[33m\]'
readonly BLUE='\[\033[34m\]'
readonly MAGENTA='\[\033[35m\]'
readonly CYAN='\[\033[36m\]'
readonly WHITE='\[\033[37m\]'

# Bright colors
readonly BRIGHT_RED='\[\033[91m\]'
readonly BRIGHT_GREEN='\[\033[92m\]'
readonly BRIGHT_YELLOW='\[\033[93m\]'
readonly BRIGHT_BLUE='\[\033[94m\]'
readonly BRIGHT_MAGENTA='\[\033[95m\]'
readonly BRIGHT_CYAN='\[\033[96m\]'

# Color definitions for regular output (without \[\] escapes)
readonly C_RESET='\033[0m'
readonly C_BOLD='\033[1m'
readonly C_DIM='\033[2m'
readonly C_RED='\033[31m'
readonly C_GREEN='\033[32m'
readonly C_YELLOW='\033[33m'
readonly C_BLUE='\033[34m'
readonly C_MAGENTA='\033[35m'
readonly C_CYAN='\033[36m'
readonly C_WHITE='\033[37m'
readonly C_BRIGHT_RED='\033[91m'
readonly C_BRIGHT_GREEN='\033[92m'
readonly C_BRIGHT_YELLOW='\033[93m'
readonly C_BRIGHT_BLUE='\033[94m'
readonly C_BRIGHT_MAGENTA='\033[95m'
readonly C_BRIGHT_CYAN='\033[96m'

# Git status function
git_prompt() {
    local branch status_color=""

    # Check if we're in a git repository
    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi

    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    # Determine git status color (use raw escape codes, not prompt-escaped ones)
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        if [[ -n $(git diff --cached --name-only 2>/dev/null) ]]; then
            status_color="$C_BRIGHT_YELLOW"  # Bright yellow for staged changes
        else
            status_color="$C_BRIGHT_RED"  # Bright red for unstaged changes
        fi
    else
        status_color="$C_BRIGHT_GREEN"      # Bright green for clean
    fi

    printf " %s(%s) " "$status_color" "$branch"
}

# Exit code display
exit_status() {
    local exit_code=$?
    [[ $exit_code -ne 0 ]] && printf " \[\033[91m\]✗%s\[\033[0m\]" "$exit_code"
}

# Dynamic prompt function that runs before each prompt
update_prompt() {
    local user_color="$GREEN"
    local host_color="$BLUE"
    local path_color="$CYAN"
    local prompt_symbol="❯"

    # Change colors based on user
    [[ $EUID -eq 0 ]] && {
        user_color="$BRIGHT_RED"
        prompt_symbol="#"
    }

    # Change colors based on SSH connection
    [[ -n $SSH_CONNECTION ]] && host_color="$MAGENTA"

    PS1="${BOLD}${user_color}\u${WHITE}@${host_color}\h ${path_color}\w$(git_prompt)$(exit_status)${RESET}\n${BLUE}${prompt_symbol}${RESET} "
}

# Real-time history sharing between sessions
# Set PROMPT_COMMAND to combine history sharing and prompt update
PROMPT_COMMAND="history -a; history -n; update_prompt"

# ==============================================================================
# ALIASES
# ==============================================================================

# List commands
alias ls='ls -lh --color=auto --group-directories-first'
alias ll='ls -lAh --color=auto --group-directories-first'
alias la='ls -la --color=auto --group-directories-first'
alias l='ls -CF --color=auto'
alias tree='tree -C'

# Safety aliases
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'

# System information
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='btop'

# Git aliases
alias lg='lazygit'

# Application shortcuts
alias vim='nvim'
alias v='nvim'
alias :q='exit'
alias files='nautilus .'

# Custom shortcuts
alias uz='7z'
alias dotfiles='cd ~/.dotfiles && nvim'
alias install-system='bash ~/.dotfiles/install.sh'
alias reload='source ~/.bashrc'
alias myip='curl ipinfo.io/ip && echo ""'

# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Enhanced project picker
pm() {
    clear

    local project_script="$HOME/.local/bin/project-manager"

    if [[ ! -x "$project_script" ]]; then
        echo "Error: project-picker script not found or not executable" >&2
        return 1
    fi

    if [[ $# -ge 1 ]]; then
        bash "$project_script" "$1"
    else
        local dir
        dir=$(bash "$project_script")
        if [[ -n "$dir" && -d "$dir" ]]; then
            cd "$dir" && vim . || return 1
        fi
    fi
}

# Build wrapper function
build() {
    # Handle --help or -h
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo "build - Wrapper function for project build.sh files"
        echo ""
        echo "This function looks for build.sh in the current directory and executes it"
        echo "with any arguments you provide."
        echo ""
        echo "Usage: build [arguments...]"
        echo ""
        echo "The arguments are passed directly to ./build.sh"
        return 0
    fi

    # Check if build.sh exists in current directory
    if [[ ! -f "./build.sh" ]]; then
        echo "Error: No build.sh found in current directory" >&2
        echo "Make sure you're in a project directory with a build.sh file" >&2
        return 1
    fi

    # Check if build.sh is executable and make it so if needed
    if [[ ! -x "./build.sh" ]]; then
        echo "Warning: build.sh is not executable. Making it executable..."
        chmod +x "./build.sh"
        if [[ $? -ne 0 ]]; then
            echo "Error: Could not make build.sh executable" >&2
            return 1
        fi
    fi

    # Execute build.sh with all provided arguments
    ./build.sh "$@"
}

# Extract various archive formats
extract() {
    [[ $# -ne 1 ]] && { echo "Usage: extract <archive>"; return 1; }
    [[ ! -f "$1" ]] && { echo "Error: '$1' is not a valid file"; return 1; }

    case "$1" in
        *.tar.bz2)   tar xjf "$1"    ;;
        *.tar.gz)    tar xzf "$1"    ;;
        *.bz2)       bunzip2 "$1"    ;;
        *.rar)       unrar x "$1"    ;;
        *.gz)        gunzip "$1"     ;;
        *.tar)       tar xf "$1"     ;;
        *.tbz2)      tar xjf "$1"    ;;
        *.tgz)       tar xzf "$1"    ;;
        *.zip)       unzip "$1"      ;;
        *.Z)         uncompress "$1" ;;
        *.7z)        7z x "$1"       ;;
        *.xz)        unxz "$1"       ;;
        *.lzma)      unlzma "$1"     ;;
        *)           echo "Error: '$1' cannot be extracted via extract()" ;;
    esac
}

# ==============================================================================
# STARTUP ACTIONS
# ==============================================================================
# Welcome message
# fastfetch
# [ -z "$TMUX" ] && [ -n "$PS1" ] && tmux attach || tmux new
echo -e "${C_GREEN}Welcome back, ${USER}!${C_RESET}"
echo -e "${C_DIM}$(date '+%A, %B %d, %Y - %H:%M:%S')${C_RESET}"
echo -e "---------------------------------------------------------------"


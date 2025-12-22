# ==============================================================================
# ENVIRONMENT VARIABLES
# ==============================================================================

# Disable fish greeting
set -g fish_greeting

# Core settings
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "nvim +Man!"
set -gx BROWSER firefox
set -gx TERM "xterm-256color"
set -gx COLORTERM "truecolor"
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"

# Development
set -gx DEBUG 1
set -gx GOPATH "$HOME/.go"
set -gx GOCACHE "$HOME/.go/cache"
set -gx GOROOT /usr/local/go 
set -gx PATH /usr/local/go/bin $GOPATH/bin $PATH

# FZF configuration
set -gx FZF_DEFAULT_COMMAND 'fd --exclude={.git,.cache,.xmake,.zig-cache,build,tmp,node_modules,elpa} --type f -H'
set -gx FZF_DEFAULT_OPTS "
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

# Fish's 'fish_add_path' is smart: it checks if the dir exists and prevents duplicates.
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/bin"
fish_add_path "/usr/local/bin"
fish_add_path "$HOME/.local/apps/nvim/bin"
fish_add_path "$HOME/.npm-global/bin"
fish_add_path "/var/lib/flatpak/exports/bin"
fish_add_path "$HOME/.local/share/flatpak/exports/bin"
fish_add_path "/usr/local/go/bin"
fish_add_path $GOPATH/bin
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/bin"


# ==============================================================================
# ALIASES & ABBREVIATIONS
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

# Application shortcuts
alias vim='nvim'
alias v='nvim'
alias :q='exit'
alias files='nemo .'
alias lg='nvim -c "lua nvgit()"'

# Custom shortcuts
alias uz='7z'
alias dotman='bash ~/.dotfiles/install.sh'
alias reload='source ~/.config/fish/config.fish'
alias myip='curl ipinfo.io/ip; echo ""'
alias lspmake='bear -- make -B'

# ==============================================================================
# FUNCTIONS
# ==============================================================================

# Project Manager
function pm
    clear
    set -l project_script "$HOME/.local/bin/project-manager"

    if not test -x "$project_script"
        echo "Error: project-picker script not found or not executable" >&2
        return 1
    end

    if count $argv > /dev/null
        bash "$project_script" $argv
    else
        set -l dir (bash "$project_script")
        if test -n "$dir"; and test -d "$dir"
            cd "$dir"; and nvim .
        end
    end
end

# Build wrapper
function build
    if contains -- $argv[1] "-h" "--help"
        echo "build - Wrapper function for project build.sh files"
        echo "Usage: build [arguments...]"
        return 0
    end

    if not test -f "./build.sh"
        echo "Error: No build.sh found in current directory" >&2
        return 1
    end

    if not test -x "./build.sh"
        chmod +x "./build.sh"
    end

    ./build.sh $argv
end

# Extract archive
function extract
    if test (count $argv) -ne 1
        echo "Usage: extract <archive>"
        return 1
    end

    if test -f $argv[1]
        switch $argv[1]
            case '*.tar.bz2'
                tar xjf $argv[1]
            case '*.tar.gz'
                tar xzf $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.rar'
                unrar x $argv[1]
            case '*.gz'
                gunzip $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.tbz2'
                tar xjf $argv[1]
            case '*.tgz'
                tar xzf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.Z'
                uncompress $argv[1]
            case '*.7z'
                7z x $argv[1]
            case '*.xz'
                unxz $argv[1]
            case '*.lzma'
                unlzma $argv[1]
            case '*'
                echo "'$argv[1]' cannot be extracted via extract()"
        end
    else
        echo "'$argv[1]' is not a valid file"
    end
end

# ==============================================================================
# PROMPT CONFIGURATION
# ==============================================================================

function fish_prompt
    set -l last_status $status
    set -l user_color (set_color green)
    set -l host_color (set_color blue)
    set -l path_color (set_color cyan)
    set -l prompt_symbol "❯"

    # Root user adjustments
    if contains $USER root
        set user_color (set_color red --bold)
        set prompt_symbol "#"
    end

    # SSH adjustments
    if set -q SSH_CONNECTION
        set host_color (set_color magenta)
    end

    # Print prompt: User@Host Path
    printf '%s%s%s@%s%s %s%s%s' \
        (set_color --bold) $user_color $USER $host_color (prompt_hostname) \
        $path_color (prompt_pwd) (set_color normal)

    # Git integration (Fish built-in)
    printf '%s' (fish_git_prompt)

    # Exit code
    if test $last_status -ne 0
        printf ' %s✗%s ' (set_color red) $last_status
    end

    # New line and symbol
    echo
    printf '%s%s%s ' (set_color blue) $prompt_symbol (set_color normal)
end

# Fish's built-in git prompt configuration
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_color_branch magenta --bold
set -g __fish_git_prompt_color_stagedstate yellow
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_cleanstate green --bold

# ==============================================================================
# STARTUP ACTIONS
# ==============================================================================
set_color green
echo "Welcome back, $USER!"
set_color 666 # Dim/Grey
echo (date '+%A, %B %d, %Y - %H:%M:%S')
set_color normal
echo "---------------------------------------------------------------"

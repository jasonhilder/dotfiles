# ------------------------
# GLOBALS
# ------------------------
set -g fish_greeting

set -x EDITOR nvim
set -x MANPAGER "nvim +Man!"
set -x TERM xterm-256color

set -x DEBUG 1

# ------------------------
# PATHS
# ------------------------
set -x PATH $HOME/bin /usr/local/bin $PATH

# Add .local/bin
set -x PATH $HOME/.local/bin $PATH

# Add neovim 
set -x PATH $HOME/.local/apps/nvim/bin $PATH

# FZF 
set -x FZF_DEFAULT_COMMAND "fd --exclude={.git,.cache,.xmake,.zig-cache,build,tmp} --type f -H"

# GOLANG
set -x GOPATH $HOME/.go
set -x GOCACHE $HOME/.go/cache
set -x PATH /usr/local/go/bin $PATH
set -x PATH $HOME/.go/bin $PATH
set -x PATH $GOPATH/bin $PATH

# PHP
set -x PATH $HOME/.phpenv/bin $PATH
set -x PATH $HOME/.phpenv/shims $PATH

# Odin
# set -x PATH $HOME/.local/share/odin-lang $PATH

# Test
set -x PATH $HOME/.local/applications/aseprite/ $PATH

# ------------------------
# ALIASES
# ------------------------
alias .. "cd .."
alias :q exit
alias dotfiles "cd ~/.dotfiles; vim"
alias wiki "cd ~/github/reimagined_barnacle; vim"
alias vim "nvim"
alias rmdir "safe_delete"

# ------------------------
# FUNCTIONS
# ------------------------
# pp (pick project)
# function pp
#     set dir (bash proj-select)
#     if test -n "$dir"
#         cd "$dir"
#     end
# end
function pp
    if test (count $argv) -ge 1
        # Pass the first argument to proj-select to add it
        bash proj-select $argv[1]
    else
        # Select a directory and cd into it
        set dir (bash proj-select)
        if test -n "$dir"
            cd "$dir"
        end
    end
end

# ------------------------
#  COLOR THEME
# ------------------------
set -l foreground bcbcbc
set -l selection 5f87af
set -l comment 767676
set -l red af5f5f
set -l orange fe8019
set -l yellow af875f
set -l green 5faf5f
set -l purple af87af
set -l cyan 5f8787
set -l blue 1f2f3f

# Kanagawa Fish shell theme
set -l foreground DCD7BA normal
set -l selection 2D4F67 brcyan
set -l comment 727169 brblack
set -l red C34043 red
set -l orange FF9E64 brred
set -l yellow C0A36E yellow
set -l green 76946A green
set -l purple 957FB8 magenta
set -l cyan 7AA89F cyan
set -l pink D27E99 brmagenta

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment



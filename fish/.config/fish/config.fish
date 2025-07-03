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
set -x PATH /usr/local/go/bin $PATH
set -x PATH $HOME/.local/go/bin $PATH
set -x PATH $HOME/.local/go/bin/gopls $PATH

# V Lang
#set -x PATH $HOME/Programming/v_lang/v/

# Odin
# set -x PATH $HOME/.local/share/odin-lang $PATH

# C3
# set -x PATH $HOME/.local/share/c3 $PATH
# add usr/local/lib to path for shared libraries i.e SDL3 etc
# set -x  LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/lib"

# ------------------------
# ALIASES
# ------------------------
alias .. "cd .."
alias :q exit
alias dotfiles "cd ~/.dotfiles; vim"
alias wiki "cd ~/github/reimagined_barnacle; vim"
alias vim "nvim"
alias rmdir "safe_delete"
alias gs "git status"

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


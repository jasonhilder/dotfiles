# Dotfiles

Minimal terminal-focused configuration for PikaOS, focused around composable CLI tools.

## Philosophy

These dotfiles make use of tool composition through tmux integration. Programs like Helix launch tools (file managers, git interfaces) in separate tmux windows rather than embedding them directly.

## Structure

```
config/
├── fish/          # Shell configuration
├── helix/         # Text editor + tmux integration scripts
├── kanata/        # Keyboard remapping
├── lf/            # File manager
└── tmux/          # Terminal multiplexer

pikaos/
├── hypr/          # Hyprland window manager
└── kitty/         # Terminal emulator

```

## Installation

```bash
# Interactive mode (prompts for confirmation)
./install.sh

# Non-interactive modes
./install.sh -l    # Symlinks only
./install.sh -i    # Package installation only
./install.sh -li   # Both, no prompts
```

The script symlinks configurations to `~/.config` and installs essential packages:
- **System tools**: fzf, fd-find, ripgrep, direnv, fastfetch, btop
- **Terminal**: fish, tmux, kitty
- **Editors**: helix (hx), lf
- **Development**: build-essential, make, bear, valgrind
- **Utilities**: bat

#!/bin/bash
# ---------------------------------------------------------------------------------
## Steps taken before running this script
# ---------------------------------------------------------------------------------

# * pikman update && pikman upgrade
# * Setup SSH keys

# * Download kanata binary
# * Setup kanata to start on boot:
#   - sudo touch /lib/systemd/system/kanata.service
#   ```
#   [Unit]
#   Description=Kanata keyboard remapper
#   Documentation=https://github.com/jtroo/kanata
#
#   [Service]
#   Type=simple
#   ExecStart=/home/user/.cargo/bin/kanata --cfg /home/user/.config/kanata/config-name.kbd
#   Restart=never
#
#   [Install]
#   WantedBy=default.target
# ```  

# * Install paq
# ```
#    git clone --depth=1 --branch=debian https://github.com/savq/paq-nvim.git \
#        "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
# ```

# * Cleanup software:
# ```
#    pikman remove chromium
# ```
# * Update kitty config font size and color scheme
# * Disable wifi and bluetooth, and bar active window in pikaOS settings
# * Clone dotfiles
# * Run this install script (symlinks configs and install software)

# ---------------------------------------------------------------------------------
## GLOBAL VARS
# ---------------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------------
## Parse arguments
# ---------------------------------------------------------------------------------
DO_LINKS=false
DO_INSTALL=false
CONFIRM_MODE=true  # only true when no args are passed

usage() {
    echo "Usage: $0 [-l] [-i]"
    echo "  -l   Only create symlinks (no confirmation)"
    echo "  -i   Only install system packages (no confirmation)"
    echo "  (no args = do both, with confirmation)"
    exit 1
}

if [ $# -eq 0 ]; then
    DO_LINKS=true
    DO_INSTALL=true
    CONFIRM_MODE=true
else
    CONFIRM_MODE=false
    while getopts ":lih" opt; do
        case $opt in
            l) DO_LINKS=true ;;
            i) DO_INSTALL=true ;;
            h) usage ;;
            *) usage ;;
        esac
    done
fi

# ---------------------------------------------------------------------------------
## Helper function for linking
# ---------------------------------------------------------------------------------
link_file() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" == "$src" ]; then
            echo "✅ Symlink already correct: $dest → $src"
            ((SKIPPED++))
        else
            echo "⚠️  $dest is a symlink but points to the wrong target."
            echo "   Replacing with correct symlink..."
            rm "$dest"
            ln -s "$src" "$dest"
            echo "🔁 Fixed: $dest → $src"
            ((CREATED++))
        fi
    elif [ -e "$dest" ]; then
        echo "⚠️  $dest exists but is not a symlink. Skipping."
        ((SKIPPED++))
    else
        mkdir -p "$(dirname "$dest")"
        ln -s "$src" "$dest"
        echo "✅ Linked: $dest → $src"
        ((CREATED++))
    fi
}

# ---------------------------------------------------------------------------------
## LINK SYMLINKS
# ---------------------------------------------------------------------------------
if [ "$DO_LINKS" = true ]; then
    if [ "$CONFIRM_MODE" = true ]; then
        read -p "❓ Do you want to create symlinks for your dotfiles? [y/N] " confirm
        case "$confirm" in
            [Yy]*) ;;  # continue below
            *) DO_LINKS=false ;;
        esac
    fi
fi

if [ "$DO_LINKS" = true ]; then
    echo "🔗 Checking and creating symlinks..."
    CREATED=0
    SKIPPED=0

    link_file "$DOTFILES_DIR/config/fish" "$HOME/.config/fish"
    link_file "$DOTFILES_DIR/config/kanata" "$HOME/.config/kanata"
    link_file "$DOTFILES_DIR/config/helix" "$HOME/.config/helix"
    link_file "$DOTFILES_DIR/config/tmux/.tmux.conf" "$HOME/.tmux.conf"

    # PikaOS Specific
    rm ~/.config/hypr/hyprland.conf  
    link_file "$DOTFILES_DIR/pikaos/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
    rm ~/.config/hypr/keybinds.conf  
    link_file "$DOTFILES_DIR/pikaos/hypr/keybinds.conf" "$HOME/.config/hypr/keybinds.conf"
    rm ~/.config/kitty/kitty.conf  
    link_file "$DOTFILES_DIR/pikaos/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

    echo ""
    echo "🧾 Summary: $CREATED symlink(s) created or fixed, $SKIPPED skipped."
    echo "Reloading hyprland..."
    hyprctl reload
    echo ""

    echo "✅ Symlink setup complete."
    echo ""
fi

# ---------------------------------------------------------------------------------
## INSTALL SYSTEM PACKAGES
# ---------------------------------------------------------------------------------
if [ "$DO_INSTALL" = true ]; then
    if [ "$CONFIRM_MODE" = true ]; then
        read -p "❓ Do you want to install system packages? [y/N] " confirm
        case "$confirm" in
            [Yy]*) ;;  # continue below
            *) DO_INSTALL=false ;;
        esac
    fi
fi

if [ "$DO_INSTALL" = true ]; then
    REQUIRED_PACKAGES=(
        # system essentials
        fzf fd-find btop fastfetch direnv ripgrep neovim hx yazi
        tmux build-essential make bear valgrind fish universal-ctags
    )

    MISSING_PACKAGES=()

    echo "🔍 Checking for missing packages..."
    echo ""

    # Check which packages are missing using dpkg
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        # dpkg-query checks for the installed status.
        # We check for a non-zero exit status which indicates the package is NOT installed.
        if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed"; then
            MISSING_PACKAGES+=("$pkg")
        fi
    done

    if [ ${#MISSING_PACKAGES[@]} -eq 0 ]; then
        echo "✅ All required packages are already installed."
    else
        echo "📦 Updating package lists..."
        # Update package lists before installing
        sudo apt update
        
        echo "📦 Installing missing packages: ${MISSING_PACKAGES[*]}"
        # Use sudo apt install for installing on Debian
        sudo apt install "${MISSING_PACKAGES[@]}"
    fi

    echo ""
    echo "✅ Package setup complete."
    echo ""
fi


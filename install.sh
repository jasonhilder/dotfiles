#!/bin/bash

# ---------------------------------------------------------------------------------
## Steps taken before running this script
# ---------------------------------------------------------------------------------

# * sudo xbps-install xbps -u
# * sudo xbps-install -Su
# * sudo xbps-install git
# * sudo xbps-install void-repo-nonfree void-repo-multilib
# * Run ssh script on usb
# * Download fonts (RobotoMono Nerd Font)
# * Download Blue icons (https://www.xfce-look.org/p/1273372)
# * Download cursor icons (https://www.xfce-look.org/p/1607387)
# * Download kanagawa gtk theme (https://www.xfce-look.org/p/1810560/)
# * stop xfce4 notifyd
#   - sudo mv /usr/share/dbus-1/services/org.xfce.xfce4-notifyd.Notifyd.service /usr/share/dbus-1/services/org.xfce.xfce4-notifyd.Notifyd.service.disabled
# * Clone dotfiles
# * Run this install script (symlinks configs, install software, install programming languages)

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

    link_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    link_file "$DOTFILES_DIR/config/dunst" "$HOME/.config/dunst"
    link_file "$DOTFILES_DIR/config/i3" "$HOME/.config/i3"
    link_file "$DOTFILES_DIR/config/kitty" "$HOME/.config/kitty"
    link_file "$DOTFILES_DIR/config/lf" "$HOME/.config/lf"
    link_file "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    link_file "$DOTFILES_DIR/config/picom" "$HOME/.config/picom"
    link_file "$DOTFILES_DIR/config/polybar" "$HOME/.config/polybar"
    link_file "$DOTFILES_DIR/config/rofi" "$HOME/.config/rofi"

    echo ""
    echo "🧾 Summary: $CREATED symlink(s) created or fixed, $SKIPPED skipped."
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
        wget curl fzf fd tree btop fastfetch direnv ripgrep 7zip xclip 
        # terminal essentials
        kitty neovim noto-fonts-emoji bash-completion mpv lf jq trash-cli 
        # i3 specific
        i3 rofi polybar picom pasystray feh dunst slurp grim maim playerctl 
        # Void extras
        vpm xset
    )

    DEV_PACKAGES=(
        # C development
        base-devel git make cmake pkg-config clang-tools-extra Bear valgrind go

        # Raylib deps (Optional comment out if not needed)
        alsa-lib-devel libglvnd-devel libX11-devel libXrandr-devel glfw-devel
        libXi-devel libXcursor-devel libXinerama-devel MesaLib-devel 
    )

    MISSING_PACKAGES=()

    echo "🔍 Checking for missing packages..."
    echo ""

    for pkg in "${REQUIRED_PACKAGES[@]}" "${DEV_PACKAGES[@]}"; do
        if ! xbps-query -l | grep -q "^ii $pkg-"; then
            MISSING_PACKAGES+=("$pkg")
        fi
    done

    if [ ${#MISSING_PACKAGES[@]} -eq 0 ]; then
        echo "✅ All packages already installed."
    else
        echo "📦 Installing missing packages: ${MISSING_PACKAGES[*]}"
        sudo xbps-install "${MISSING_PACKAGES[@]}"
    fi

    echo ""
    echo "✅ Package setup complete."
    echo ""
fi


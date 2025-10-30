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
# * stop xfce4 notifyd
#   - sudo mv /usr/share/dbus-1/services/org.xfce.xfce4-notifyd.Notifyd.service /usr/share/dbus-1/services/org.xfce.xfce4-notifyd.Notifyd.service.disabled
# * Clone dotfiles
# * Run this install script (symlinks configs, install software, install programming languages)

# ---------------------------------------------------------------------------------
## GLOBAL VARS
# ---------------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------------
## LINK SYMLINKS IF NOT ALREADY THERE
# ---------------------------------------------------------------------------------
declare -A FILES_TO_SYMLINK=(
    ["$DOTFILES_DIR/bash/.bashrc"]="$HOME/.bashrc"
    ["$DOTFILES_DIR/scripts"]="$HOME/.local/bin"
)

read -p "❓ Do you want to create symlinks for your dotfiles? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        echo "🔗 Checking and creating symlinks..."
        CREATED=0
        SKIPPED=0
        
        # Handle the main FILES_TO_SYMLINK array
        for src in "${!FILES_TO_SYMLINK[@]}"; do
            dest="${FILES_TO_SYMLINK[$src]}"
            if [ -L "$dest" ]; then
                if [ "$(readlink "$dest")" == "$src" ]; then
                    echo "✅ Symlink already correct: $dest → $src"
                    ((SKIPPED++))
                else
                    echo "⚠️  $dest is a symlink, but points to the wrong target."
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
        done
        
        # Dynamically handle all subdirectories in config/
        if [ -d "$DOTFILES_DIR/config" ]; then
            for config_dir in "$DOTFILES_DIR/config"/*/ ; do
                [ -d "$config_dir" ] || continue
                folder_name=$(basename "$config_dir")
                src="$DOTFILES_DIR/config/$folder_name"
                dest="$HOME/.config/$folder_name"
                
                if [ -L "$dest" ]; then
                    if [ "$(readlink "$dest")" == "$src" ]; then
                        echo "✅ Symlink already correct: $dest → $src"
                        ((SKIPPED++))
                    else
                        echo "⚠️  $dest is a symlink, but points to the wrong target."
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
                    mkdir -p "$HOME/.config"
                    ln -s "$src" "$dest"
                    echo "✅ Linked: $dest → $src"
                    ((CREATED++))
                fi
            done
        fi
        
        echo ""
        echo "🧾 Summary: $CREATED symlink(s) created or fixed, $SKIPPED skipped."
        echo ""
        ;;
    * ) ;;
esac

# ---------------------------------------------------------------------------------
## Check and install system packages
# ---------------------------------------------------------------------------------
read -p "❓ Do you want to install system packages? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        REQUIRED_PACKAGES=(
            curl ripgrep mpv btop tree valgrind kitty
            fastfetch direnv fd bash-completion
			go emacs-x11 rofi i3 polybar picom
			pasystray volumeicon feh dunst autotiling
			slurp grim
        )

        # Development packages (equivalent to Fedora's development groups)
        DEV_PACKAGES=(
            base-devel git make cmake pkg-config
        )

        MISSING_PACKAGES=()

        echo "🔍 Checking for missing packages..."
        echo ""

        # Check regular packages
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
        ;;
    * ) ;;
esac

echo "--------------------------------------------"
echo "Install complete!"
echo ""
echo "ℹ️  Note: You may need to restart your shell or source your .bashrc"
echo "   to pick up any new environment changes."
echo ""

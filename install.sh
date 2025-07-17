#!/bin/bash

# Check if RPM Fusion repos are already installed
FREE_REPO="/etc/yum.repos.d/rpmfusion-free.repo"
NONFREE_REPO="/etc/yum.repos.d/rpmfusion-nonfree.repo"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A FILES_TO_SYMLINK=(
    ["$DOTFILES_DIR/tmux/.tmux.conf"]="$HOME/.tmux.conf"
    ["$DOTFILES_DIR/kitty"]="$HOME/.config/kitty"
    ["$DOTFILES_DIR/fish"]="$HOME/.config/fish"
    ["$DOTFILES_DIR/nvim"]="$HOME/.config/nvim"
    ["$DOTFILES_DIR/rofi"]="$HOME/.config/rofi"
    ["$DOTFILES_DIR/sway"]="$HOME/.config/sway"
    ["$DOTFILES_DIR/waybar"]="$HOME/.config/waybar"
)

read -p "❓ Do you want to create symlinks for your dotfiles? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        echo "🔗 Checking and creating symlinks..."

        CREATED=0
        SKIPPED=0

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
                ln -s "$src" "$dest"
                echo "✅ Linked: $dest → $src"
                ((CREATED++))
            fi
        done

        echo ""
        echo "🧾 Summary: $CREATED symlink(s) created or fixed, $SKIPPED skipped."
        echo ""
        ;;
    * ) ;;
esac

echo "🔍 Checking for RPM repos..."
echo ""
if [[ -f "$FREE_REPO" && -f "$NONFREE_REPO" ]]; then
    echo "✅ RPM Fusion free and non-free repos are already enabled."
    echo ""
else
    read -p "❓ Do you want to enable free/non free repos? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
            sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            echo ""
            echo "✅ Repos added."
            echo ""
            ;;
        * ) ;;
    esac
fi

read -p "❓ Do you want to install system packages? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        REQUIRED_PACKAGES=(
            curl ripgrep fzf mpv btop tree valgrind kitty
            fish fastfetch direnv lazygit neovim fd-find
        )

        GROUP_IDS=(
            "development-tools"
            "c-development"
        )

        MISSING_PACKAGES=()

        echo "🔍 Checking for missing individual packages..."
        echo ""

        for pkg in "${REQUIRED_PACKAGES[@]}"; do
            if ! rpm -q "$pkg" &>/dev/null; then
                MISSING_PACKAGES+=("$pkg")
            fi
        done

        if [ ${#MISSING_PACKAGES[@]} -eq 0 ]; then
            echo "✅ All individual packages already installed."
        else
            echo "📦 Installing missing packages: ${MISSING_PACKAGES[*]}"
            sudo dnf install -y "${MISSING_PACKAGES[@]}"
        fi

        echo ""
        echo "🔍 Checking for missing package groups..."
        echo ""

        INSTALLED_GROUP_IDS=$(dnf group list --installed | awk 'NR > 1 {print $1}' | sed 's/^ *//')
        echo ""

        for group_id in "${GROUP_IDS[@]}"; do
            if echo "$INSTALLED_GROUP_IDS" | grep -Fxq "$group_id"; then
                echo "✅ Group '$group_id' is already installed."
            else
                echo "📦 Need to install group '$group_id'..."
                sudo dnf groupinstall -y "$group_id"
            fi
        done

        echo ""
        echo "✅ Package setup complete."
        echo ""
        ;;
    * ) ;;
esac

# read -p "❓ Do you want to install docker? [y/N] " confirm
# case "$confirm" in
#     [Yy]* )
#         sudo dnf install docker-cli containerd docker-compose
#         echo ""
#         echo "✅ Docker installed."
#         ;;
#     * ) ;;
# esac

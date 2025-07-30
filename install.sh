#!/bin/bash

# ---------------------------------------------------------------------------------
## GLOBAL VARS
# ---------------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# RPM Fusion repo locations 
FREE_REPO="/etc/yum.repos.d/rpmfusion-free.repo"
NONFREE_REPO="/etc/yum.repos.d/rpmfusion-nonfree.repo"

# ---------------------------------------------------------------------------------
## LINK SYMLINKS IF NOT ALREADY THERE
# ---------------------------------------------------------------------------------
declare -A FILES_TO_SYMLINK=(
    ["$DOTFILES_DIR/bash/.bashrc"]="$HOME/.bashrc"
    ["$DOTFILES_DIR/tmux/.tmux.conf"]="$HOME/.tmux.conf"
    ["$DOTFILES_DIR/kanata/.keymap.kbd"]="$HOME/.keymap.kbd"
    ["$DOTFILES_DIR/kitty"]="$HOME/.config/kitty"
    ["$DOTFILES_DIR/fish"]="$HOME/.config/fish"
    ["$DOTFILES_DIR/nvim"]="$HOME/.config/nvim"
    ["$DOTFILES_DIR/rofi"]="$HOME/.config/rofi"
    ["$DOTFILES_DIR/sway"]="$HOME/.config/sway"
    ["$DOTFILES_DIR/waybar"]="$HOME/.config/waybar"
    ["$DOTFILES_DIR/scripts"]="$HOME/.local/bin"
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

# ---------------------------------------------------------------------------------
## Ensure Free and non Free repos are enabled
# ---------------------------------------------------------------------------------
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

            echo "Updating system with new repos enabled..."
            echo ""
            sudo dnf check-update
            sudo dnf update

            echo ""
            echo "✅ System updated."
            echo ""
            ;;
        * ) ;;
    esac
fi

# ---------------------------------------------------------------------------------
## Check and install system packages
# ---------------------------------------------------------------------------------
read -p "❓ Do you want to install system packages? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        REQUIRED_PACKAGES=(
            curl ripgrep fzf mpv btop tree valgrind kitty
            fastfetch direnv lazygit neovim fd-find bash-completion
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

# ---------------------------------------------------------------------------------
## Check and install docker
# ---------------------------------------------------------------------------------
# Check if Docker is installed
if command -v docker >/dev/null 2>&1; then
    echo "✅ Docker is already installed."
else
    echo ""
    echo "❌ Docker is not installed."
    read -p "❓ Do you want to install Docker? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            echo "🔧 Installing Docker..."
            sudo dnf install -y docker-cli containerd docker-compose
            sudo usermod -aG docker $USER

            echo ""
            echo "✅ Added $USER to the docker group. Please log out and log back in for this to take effect."
            echo ""
            echo "✅ Docker installed."
            ;;
        * )
            echo "❌ Docker installation skipped."
            ;;
    esac
fi

# ---------------------------------------------------------------------------------
## Zig language
# ---------------------------------------------------------------------------------
if command -v zig >/dev/null 2>&1; then
    echo""
else
    echo ""
    read -p "❓ Do you want to install Zig lang? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            echo "🔧 Installing zig..."
            sudo dnf install zig 

            echo ""
            echo "✅ Zig installed."
            ;;
        * )
            echo "❌ Zig installation skipped."
            ;;
    esac
fi

# ---------------------------------------------------------------------------------
## TODO golang
# ---------------------------------------------------------------------------------
# check and install golang

if command -v go >/dev/null 2>&1; then
    echo""
else
    echo ""
    read -p "❓ Do you want to install GoLang? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            echo "🔍 Fetching the latest Go version..."
            echo ""
            URL=$(curl -s https://go.dev/dl/ \
                  | grep -Eo 'go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64\.tar\.gz' \
                  | head -1)
            
            LATEST_URL="https://go.dev/dl/$URL"
            
            if [ -z "$LATEST_URL" ]; then
              echo "❌ Failed to fetch the Go download URL. Exiting."
              echo ""
            fi
            
            FILENAME=$(basename "$LATEST_URL")
            echo "📦 Found Go archive: $FILENAME"
            echo ""
            echo "📥 Downloading $FILENAME..."
            curl -LO "$LATEST_URL"
            
            echo "🧹 Removing previous Go installation (if any)..."
            echo ""
            sudo rm -rf /usr/local/go
            
            echo "📂 Extracting Go archive to /usr/local..."
            echo ""
            sudo tar -C /usr/local -xzf "$FILENAME"

            echo "✅ Go installation complete!"
            echo ""
           ;;
        * )
            echo "❌ Go installation skipped."
        ;;
fi

# check and install gopls language server

echo "--------------------------------------------"
echo "Install complete!"
echo ""

# ---------------------------------------------------------------------------------
## TODO phpenv
# ---------------------------------------------------------------------------------
# check and install phpenv with all dependencies
#

## Possible extras:
# ---------------------------------------------------------------------------------
# 1. Theme firefox
# 2. Add minimal theme to sddm (system essentials?)
# 3. Install nerdfont (system essentials?)

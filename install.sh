#!/bin/bash

# ---------------------------------------------------------------------------------
## GLOBAL VARS
# ---------------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Void Linux repositories
NONFREE_REPO="/etc/xbps.d/00-repository-nonfree.conf"

# ---------------------------------------------------------------------------------
## LINK SYMLINKS IF NOT ALREADY THERE
# ---------------------------------------------------------------------------------
declare -A FILES_TO_SYMLINK=(
    ["$DOTFILES_DIR/bash/.bashrc"]="$HOME/.bashrc"
    ["$DOTFILES_DIR/kitty"]="$HOME/.config/kitty"
    ["$DOTFILES_DIR/nvim"]="$HOME/.config/nvim"
    ["$DOTFILES_DIR/rofi"]="$HOME/.config/rofi"
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
                # Create parent directory if it doesn't exist
                mkdir -p "$(dirname "$dest")"
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
## Ensure nonfree and multilib repos are enabled
# ---------------------------------------------------------------------------------
echo "🔍 Checking for Void Linux repositories..."
echo ""

# Check if nonfree repo is enabled
if [[ -f "$NONFREE_REPO" ]]; then
    echo "✅ Void nonfree repository is already enabled."
else
    read -p "❓ Do you want to enable the nonfree repository? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            echo "🔧 Enabling nonfree repository..."
            sudo mkdir -p /etc/xbps.d
            echo "repository=https://repo-default.voidlinux.org/current/nonfree" | sudo tee "$NONFREE_REPO" > /dev/null
            echo "✅ Nonfree repository enabled."
            ;;
        * ) ;;
    esac
fi

# Check if multilib repo is enabled (for 32-bit packages on x86_64)
if grep -q "multilib" /etc/xbps.d/*.conf 2>/dev/null; then
    echo "✅ Multilib repository is already enabled."
else
    if [ "$(uname -m)" = "x86_64" ]; then
        read -p "❓ Do you want to enable the multilib repository? [y/N] " confirm
        case "$confirm" in
            [Yy]* )
                echo "🔧 Enabling multilib repository..."
                echo "repository=https://repo-default.voidlinux.org/current/multilib/nonfree" | sudo tee /etc/xbps.d/10-repository-multilib-nonfree.conf > /dev/null
                echo "repository=https://repo-default.voidlinux.org/current/multilib" | sudo tee /etc/xbps.d/10-repository-multilib.conf > /dev/null
                echo "✅ Multilib repository enabled."
                ;;
            * ) ;;
        esac
    fi
fi

echo ""
echo "🔄 Synchronizing package database..."
sudo xbps-install -S
echo ""

# ---------------------------------------------------------------------------------
## Check and install system packages
# ---------------------------------------------------------------------------------
read -p "❓ Do you want to install system packages? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        REQUIRED_PACKAGES=(
            curl ripgrep fzf mpv btop tree valgrind kitty
            fastfetch direnv neovim fd bash-completion
            xdotool wmctrl rofi lazygit redshift-gtk
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

# ---------------------------------------------------------------------------------
## Golang
# ---------------------------------------------------------------------------------

if command -v go >/dev/null 2>&1; then
    echo "✅ Go is already installed: $(go version)"
else
    echo ""
    read -p "❓ Do you want to install GoLang? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            # First try installing from Void repos
            echo "🔍 Checking if Go is available in Void repositories..."
            if xbps-query -R go >/dev/null 2>&1; then
                echo "📦 Installing Go from Void repositories..."
                sudo xbps-install -y go
                echo "✅ Go installed from repositories!"
            else
                # Fallback to manual installation
                echo "🔍 Fetching the latest Go version from golang.org..."
                echo ""
                URL=$(curl -s https://go.dev/dl/ \
                      | grep -Eo 'go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64\.tar\.gz' \
                      | head -1)
                
                LATEST_URL="https://go.dev/dl/$URL"
                
                if [ -z "$URL" ]; then
                  echo "❌ Failed to fetch the Go download URL. Exiting."
                  echo ""
                else
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
                    echo "ℹ️  Add '/usr/local/go/bin' to your PATH if not already done."
                    
                    # Clean up downloaded archive
                    rm -f "$FILENAME"
                fi
            fi
            echo ""
           ;;
        * )
            echo "❌ Go installation skipped."
        ;;
    esac
fi

echo "--------------------------------------------"
echo "Install complete!"
echo ""
echo "ℹ️  Note: You may need to restart your shell or source your .bashrc"
echo "   to pick up any new environment changes."
echo ""

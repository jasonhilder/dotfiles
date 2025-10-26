#!/bin/bash

# ---------------------------------------------------------------------------------
## GLOBAL VARS
# ---------------------------------------------------------------------------------

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------------
## LINK SYMLINKS IF NOT ALREADY THERE
# ---------------------------------------------------------------------------------
declare -A FILES_TO_SYMLINK=(
    ["$DOTFILES_DIR/bash/.bashrc"]="$HOME/.bashrc"
    ["$DOTFILES_DIR/kitty"]="$HOME/.config/kitty"
    ["$DOTFILES_DIR/nvim"]="$HOME/.config/nvim"
    ["$DOTFILES_DIR/tmux"]="$HOME/.config/tmux"
    ["$DOTFILES_DIR/lazygit"]="$HOME/.config/lazygit"
    ["$DOTFILES_DIR/scripts"]="$HOME/.local/bin"
    ["$DOTFILES_DIR/emacs/.emacs.d"]="$HOME/.emacs.d"
)

read -p "Do you want to create symlinks for your dotfiles? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        echo "Checking and creating symlinks..."

        CREATED=0
        SKIPPED=0

        for src in "${!FILES_TO_SYMLINK[@]}"; do
            dest="${FILES_TO_SYMLINK[$src]}"

            if [ -L "$dest" ]; then
                if [ "$(readlink "$dest")" == "$src" ]; then
                    echo "Symlink already correct: $dest → $src"
                    ((SKIPPED++))
                else
                    echo "$dest is a symlink, but points to the wrong target."
                    echo "Replacing with correct symlink..."
                    rm "$dest"
                    ln -s "$src" "$dest"
                    echo "Fixed: $dest → $src"
                    ((CREATED++))
                fi
            elif [ -e "$dest" ]; then
                echo "$dest exists but is not a symlink. Skipping."
                ((SKIPPED++))
            else
                # Create parent directory if it doesn't exist
                mkdir -p "$(dirname "$dest")"
                ln -s "$src" "$dest"
                echo "Linked: $dest → $src"
                ((CREATED++))
            fi
        done

        echo ""
        echo "Summary: $CREATED symlink(s) created or fixed, $SKIPPED skipped."
        echo ""
        ;;
    * ) ;;
esac

# ---------------------------------------------------------------------------------
## Ensure multiverse and universe repositories are enabled
# ---------------------------------------------------------------------------------
echo "Checking for Ubuntu/Pop!_OS repositories..."
echo ""

# Enable multiverse and universe repositories if not already enabled (they contain non-free software)
if ! grep -r "multiverse" /etc/apt/sources.list /etc/apt/sources.list.d; then
    read -p "Do you want to enable the 'multiverse' repository for non-free software? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            echo "Enabling multiverse repository..."
            sudo add-apt-repository multiverse
            sudo apt update
            ;;
        * ) ;;
    esac
fi

if ! grep -r "universe" /etc/apt/sources.list /etc/apt/sources.list.d; then
    read -p "Do you want to enable the 'universe' repository? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            echo "Enabling universe repository..."
            sudo add-apt-repository universe
            sudo apt update
            ;;
        * ) ;;
    esac
fi


echo ""
echo "Synchronizing package database..."
sudo apt update
echo ""

# ---------------------------------------------------------------------------------
## Check and install system packages
# ---------------------------------------------------------------------------------
read -p "Do you want to install system packages? [y/N] " confirm
case "$confirm" in
    [Yy]* )
        REQUIRED_PACKAGES=(
            curl ripgrep fzf mpv btop tree valgrind kitty
            direnv fd-find bash-completion xclip gnome-tweaks
        )

        # Manually, lazygit, neovim, paq plugin manager, difftastic

        # Development packages (equivalent to Fedora's development groups)
        DEV_PACKAGES=(
            build-essential git make cmake pkg-config
        )

        MISSING_PACKAGES=()

        echo "Checking for missing packages..."
        echo ""

        # Check regular packages
        for pkg in "${REQUIRED_PACKAGES[@]}" "${DEV_PACKAGES[@]}"; do
            if ! dpkg -l | grep -q "^ii  $pkg "; then
                MISSING_PACKAGES+=("$pkg")
            fi
        done

        if [ ${#MISSING_PACKAGES[@]} -eq 0 ]; then
            echo "All packages already installed."
        else
            echo "Installing missing packages: ${MISSING_PACKAGES[*]}"
            sudo apt install -y "${MISSING_PACKAGES[@]}"
        fi

        echo ""
        echo "Package setup complete."
        echo ""
        ;;
    * ) ;;
esac

# ---------------------------------------------------------------------------------
## Golang
# ---------------------------------------------------------------------------------

if command -v go >/dev/null 2>&1; then
    echo "Go is already installed: $(go version)"
else
    echo ""
    read -p "Do you want to install GoLang? [y/N] " confirm
    case "$confirm" in
        [Yy]* )
            # Fallback to manual installation
            echo "Fetching the latest Go version from golang.org..."
            echo ""
            URL=$(curl -s https://go.dev/dl/ \
                  | grep -Eo 'go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64\.tar\.gz' \
                  | head -1)

            LATEST_URL="https://go.dev/dl/$URL"

            if [ -z "$URL" ]; then
              echo "Failed to fetch the Go download URL. Exiting."
              echo ""
            else
                FILENAME=$(basename "$LATEST_URL")
                echo "Found Go archive: $FILENAME"
                echo ""
                echo "Downloading $FILENAME..."
                curl -LO "$LATEST_URL"

                echo "Removing previous Go installation (if any)..."
                echo ""
                sudo rm -rf /usr/local/go

                echo "Extracting Go archive to /usr/local..."
                echo ""
                sudo tar -C /usr/local -xzf "$FILENAME"

                echo "Go installation complete!"
                echo "Add '/usr/local/go/bin' to your PATH if not already done."

                # Clean up downloaded archive
                rm -f "$FILENAME"
            fi
            echo ""
           ;;
        * )
            echo "Go installation skipped."
        ;;
    esac
fi

echo "--------------------------------------------"
echo "Install complete!"
echo ""
echo "Note: You may need to restart your shell or source your .bashrc"
echo "to pick up any new environment changes."
echo ""


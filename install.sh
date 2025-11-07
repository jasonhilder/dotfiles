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
## LINK SYMLINKS IF NOT ALREADY THERE
# ---------------------------------------------------------------------------------
read -p "❓ Do you want to create symlinks for your dotfiles? [y/N] " confirm
case "$confirm" in
    [Yy]*)
        echo "🔗 Checking and creating symlinks..."
        CREATED=0
        SKIPPED=0
        
        # Handle bash symlink directly
        src="$DOTFILES_DIR/bash/.bashrc"
        dest="$HOME/.bashrc"
        
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
        
        # Dynamically handle all subdirectories in config/
        if [ -d "$DOTFILES_DIR/config" ]; then
            for config_dir in "$DOTFILES_DIR/config"/*/; do
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
    *) ;;
esac

# ---------------------------------------------------------------------------------
## Check and install system packages
# ---------------------------------------------------------------------------------
read -p "❓ Do you want to install system packages? [y/N] " confirm
case "$confirm" in
    [Yy]*)
        REQUIRED_PACKAGES=(
            wget curl fzf fd tree btop fastfetch direnv ripgrep 7zip xclip 
            kitty neovim noto-fonts-emoji bash-completion mpv lf trash-cli
            rofi i3 polybar picom pasystray feh dunst slurp grim maim playerctl 
        )

  # Development packages (equivalent to Fedora's development groups)
  DEV_PACKAGES=(
      base-devel git make cmake pkg-config valgrind go
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
*) ;;
esac

echo "--------------------------------------------"
echo "Install complete!"
echo ""
echo "ℹ️  Note: You may need to restart your shell or source your .bashrc"
echo "   to pick up any new environment changes."
echo ""

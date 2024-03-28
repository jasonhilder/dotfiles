Dotfiles :)
--------------------------------

![Preview Image of system1](https://github.com/jasonhilder/dotfiles/blob/main/screenshots/preview-1.png)
![Preview Image of system2](https://github.com/jasonhilder/dotfiles/blob/main/screenshots/preview-2.png)

Steps To Reproduce
---

### :warning: 
### Note this is intended for a fresh install of Pop_Os
*Most of this should (no guarantee) work on any ubuntu/debian based distros that use the apt package manager*

### Generate ssh key 
```
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_rsa

cat ~/.ssh/id_rsa.pub
```
*Add ssh key to github so you can git clone the repo*

### Configure git global user
```
git config --global user.name "first_name last_name"

git config --global user.email "email@example.com"
```

### Git clone dotfiles
```
cd ~ && git clone git@github.com:jasonhilder/dotfiles.git 
```

### Run install script
```
cd ~ && ./dotfiles/system_install.sh
```
*The script will install the following:*

    - Git
    - make
    - gcc
    - build-essential
    - rg (Ripgrep)
    - gnu stow
    - xclip
    - unzip
    - tree
    - neofetch
    - btop
    - zsh && Oh My Zsh
    - Docker
    - Docker Compose
    - Zola
    - Lazy Git
    - Lazy Docker
    - Vscode
    - Transmission

### Gnome tweaks 
    - focus windows on hover
    - set capslock to control
    - right alt never selects 3rd level

### Gnome Settings
    - Set workspaces to 5 
    - Set specific shortcuts
    - dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-5 "['<Alt>p']"
    - dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-5 "['<Shift><Alt>p']"

### Set up browser and add extensions
    - bitwarden
    - gnome shell integration 
    - simply workspaces
    - disable workspace switcher

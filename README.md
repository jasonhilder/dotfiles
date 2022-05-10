linux dotfiles managed with stow
--------------------------------

install GNU Stow
```
sudo apt install stow
```

Clean install steps:

```
cd ~

git clone git@github.com:jasonhilder/dotfiles.git

cd ~/dotfiles

stow zsh/ tmux/ alacritty/ nvim/
```

For vim/nvim to have access to aliases after symlinking the .zshrc file run:
```
source ~/.zshrc && zshalias
```

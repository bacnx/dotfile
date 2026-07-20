# Terminal Config (Linux)

![screenshot-1](./images/screenshot-1.png)
![screenshot-2](./images/screenshot-2.png)

## Requirements

- [Nerd Font (v3)](https://www.nerdfonts.com/)
- Xclip: for Tmux copy directly to the system clipboard
```sh
sudo apt-get install xclip
```

## Install

### Link configs
```sh
ln -s $PWD/.zshrc ~/.zshrc
```
```sh
ln -s $PWD/.p10k.zsh ~/.p10k.zsh
```
```sh
ln -s $PWD/.tmux.conf ~/.tmux.conf
```
```sh
ln -s $PWD/.czrc ~/.czrc
```
```sh
ln -s $PWD/nvim ~/.config/nvim
```
```sh
ln -s $PWD/lazygit ~/.config/lazygit
```


### [Neovim (v0.12+)](https://neovim.io/)

Plugins are managed by the builtin `vim.pack` (requires v0.12), pinned in
`nvim/nvim-pack-lock.json`. No plugin-manager bootstrap needed.


- [lazygit](https://github.com/jesseduffield/lazygit?tab=readme-ov-file#installation)
- [ripgrep](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation)

### [Oh My Zsh](https://ohmyz.sh/#install)

- [zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#oh-my-zsh)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)

### [Tmux](https://github.com/tmux/tmux/wiki)

- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

### Terminal

- [eza](https://github.com/eza-community/eza/blob/main/INSTALL.md)

### [Commitizen](https://github.com/commitizen/cz-cli)
```shell
npm install commitizen -g
npm install -g cz-conventional-changelog
```

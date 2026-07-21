# Terminal Config (Linux)

![screenshot-1](./images/screenshot-1.png)
![screenshot-2](./images/screenshot-2.png)

## Requirements

- [Nerd Font (v3)](https://www.nerdfonts.com/)
- [win32yank](https://github.com/equalsraf/win32yank): for Tmux and Neovim to copy
  directly to the Windows clipboard under WSL2. Both configs use it, so the system
  clipboard behaves the same in either.
```sh
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe | sudo tee /usr/local/bin/win32yank.exe > /dev/null
sudo chmod +x /usr/local/bin/win32yank.exe
```
> On a native X11/Wayland Linux box use `xclip`/`wl-clipboard` instead and change the
> `copy-pipe-and-cancel` command in `tmux/tmux.conf` to match.

## Install

### Link configs
```sh
ln -s $PWD/.zshrc ~/.zshrc
```
```sh
ln -s $PWD/.p10k.zsh ~/.p10k.zsh
```
```sh
ln -s $PWD/tmux ~/.config/tmux
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
```sh
# herdr writes logs/sockets/session state into ~/.config/herdr, so symlink
# only the config file, not the whole directory.
ln -s $PWD/herdr/config.toml ~/.config/herdr/config.toml
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

Config lives at `tmux/tmux.conf`, loaded from `~/.config/tmux/tmux.conf` (tmux 3.1+).
Prefix is `C-s`. Pane navigation, resizing, and vim-aware pane switching are all bound to
both `hjkl` and the arrow keys.

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm) and used **only** for
session persistence — the status bar and vim-tmux-navigator integration are hand-rolled in
the config, so tmux is fully usable before plugins are installed.

```sh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```
Then start tmux and press `prefix + I` to install
[tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) and
[tmux-continuum](https://github.com/tmux-plugins/tmux-continuum).

- Sessions auto-save every 15 minutes; save manually with `prefix + S`, restore with
  `prefix + C-r`. Auto-restore is deliberately off, since the session auto-rename hooks
  would rename sessions as they are restored.
- Resurrect's save key is moved off its `prefix + C-s` default, which would otherwise
  collide with `send-prefix` (the prefix is itself `C-s`).
- `prefix + r` reloads the config.

> `~/.config/tmux` is a symlink into this repo, so the live tmux config follows whichever
> branch is checked out — same as `~/.config/nvim`.

### Terminal

- [eza](https://github.com/eza-community/eza/blob/main/INSTALL.md)

### [Commitizen](https://github.com/commitizen/cz-cli)
```shell
npm install commitizen -g
npm install -g cz-conventional-changelog
```

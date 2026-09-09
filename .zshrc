# ─────────────────────────────────────────────────────────────
# Platform detection
# ─────────────────────────────────────────────────────────────
if [[ -n "$WSL_DISTRO_NAME" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=1
else
    IS_WSL=0
fi

# Machine-local overrides, split in two: this one runs before PATH and compinit,
# for anything the detection below has to see. See .zshrc.local.example.
[[ -f ~/.zshrc.local.pre ]] && source ~/.zshrc.local.pre

# ─────────────────────────────────────────────────────────────
# History
# ─────────────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt HIST_IGNORE_DUPS      # drop a command that repeats the one before it
setopt HIST_IGNORE_SPACE     # a leading space keeps the command out of history
setopt EXTENDED_HISTORY      # record a timestamp per entry
setopt HIST_FIND_NO_DUPS     # searching backwards never offers the same line twice

# SHARE_HISTORY is deliberately off. It imports other shells' commands into this
# one's list, so the "previous command" HIST_IGNORE_DUPS compares against is often
# from another pane — which lets duplicates straight through. INC_APPEND_HISTORY
# keeps the part worth having: each command is written as it runs, so a pane that
# is killed rather than exited doesn't take its history with it.
setopt INC_APPEND_HISTORY

# ─────────────────────────────────────────────────────────────
# Options
# ─────────────────────────────────────────────────────────────
setopt AUTO_CD

# Prefer en_US.UTF-8, but only if the system actually generated it — Arch usually
# has it, minimal WSL/Ubuntu images often only ship C.UTF-8. Exporting a locale
# that doesn't exist makes anything calling `manpath` (nvm does, on every shell)
# warn "can't set the locale" on startup.
() {
    local -a avail=(${(f)"$(locale -a 2>/dev/null)"})
    if (( $avail[(I)(en_US.utf8|en_US.UTF-8)] )); then
        export LANG=en_US.UTF-8
    elif (( $avail[(I)(C.utf8|C.UTF-8)] )); then
        export LANG=C.UTF-8
    fi
}

# Assigned rather than appended: appending to itself adds another copy on every
# nested shell, and unlike PATH there is no `typeset -U` to collapse them. Keys
# left unset here keep ls/eza's built-in defaults, so two rules is the whole need:
# dircolors paints other-writable dirs blue-on-green, which is unreadable.
export LS_COLORS="ow=1;34:tw=1;34"

# ─────────────────────────────────────────────────────────────
# Clipboard — one interface over WSL / Wayland / X11
# ─────────────────────────────────────────────────────────────
# Backend selection lives in bin/clip (symlinked to ~/.local/bin/clip) so zsh,
# Neovim and tmux all resolve the clipboard the same way. Falls back to zsh's
# internal buffer only if the script itself is missing.
if (( $+commands[clip] )); then
    _clip_copy()  { clip -i }
    _clip_paste() { clip -o }
else
    _clip_copy()  { cat > /dev/null }
    _clip_paste() { printf '%s' "$CUTBUFFER" }
fi

# ─────────────────────────────────────────────────────────────
# Vi mode
# ─────────────────────────────────────────────────────────────
bindkey -v
export KEYTIMEOUT=20

# jk leaves insert mode
bindkey -M viins 'jk' vi-cmd-mode

# Block cursor in normal mode, beam in insert mode
_set_cursor_shape() {
    case $KEYMAP in
        vicmd)          printf '\e[2 q' ;;
        viins|main|'')  printf '\e[6 q' ;;
    esac
}
zle -N zle-keymap-select _set_cursor_shape
_cursor_on_init() { printf '\e[6 q' }
zle -N zle-line-init _cursor_on_init

# Sync vi-mode yank/delete/change/put with the system clipboard
_vi_yank_clip()       { zle vi-yank;     printf '%s' "$CUTBUFFER" | _clip_copy }
_vi_yank_eol_clip()   { zle vi-yank-eol; printf '%s' "$CUTBUFFER" | _clip_copy }
_vi_delete_clip()     { zle vi-delete;   printf '%s' "$CUTBUFFER" | _clip_copy }
_vi_change_clip()     { zle vi-change;   printf '%s' "$CUTBUFFER" | _clip_copy }
_vi_put_after_clip()  { CUTBUFFER=$(_clip_paste); zle vi-put-after }
_vi_put_before_clip() { CUTBUFFER=$(_clip_paste); zle vi-put-before }

zle -N _vi_yank_clip
zle -N _vi_yank_eol_clip
zle -N _vi_delete_clip
zle -N _vi_change_clip
zle -N _vi_put_after_clip
zle -N _vi_put_before_clip

bindkey -M vicmd 'y' _vi_yank_clip
bindkey -M vicmd 'Y' _vi_yank_eol_clip
bindkey -M vicmd 'd' _vi_delete_clip
bindkey -M vicmd 'c' _vi_change_clip
bindkey -M vicmd 'p' _vi_put_after_clip
bindkey -M vicmd 'P' _vi_put_before_clip

# `v` opens the line being typed in $EDITOR (set after PATH, below); save and quit
# runs it. Long pipelines are far easier to fix in nvim than on one terminal row.
# This displaces vicmd's default visual-mode; `V` still starts visual-line-mode.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# ─────────────────────────────────────────────────────────────
# PATH
# ─────────────────────────────────────────────────────────────
# Keep entries unique so re-sourcing (or `exec zsh`) can't grow PATH forever
typeset -U path PATH

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
[[ -n "$GOROOT" ]] && export PATH="$PATH:$GOROOT/bin"

# Guarded because bun is not installed everywhere — an unconditional prepend put a
# directory that does not exist into the third-priority PATH slot.
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Ruby gems — glob the version rather than pinning 3.0.0
for _gemdir in "$HOME"/.local/share/gem/ruby/*/bin(N); do
    export PATH="$PATH:$_gemdir"
done
unset _gemdir

# Neovim installed from tarball rather than a package
[[ -d /opt/nvim-linux-x86_64/bin ]] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# ─────────────────────────────────────────────────────────────
# Editor
# ─────────────────────────────────────────────────────────────
# Set here rather than up with the other options: nvim ships as a tarball under
# /opt, which only joins PATH a few lines above, so detecting it any earlier
# would silently fall through to vim. edit-command-line reads this too.
if (( $+commands[nvim] )); then
    export EDITOR=nvim
elif (( $+commands[vim] )); then
    export EDITOR=vim
fi

# ─────────────────────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────────────────────
alias v=nvim
alias lg=lazygit

# fastfetch where available, else neofetch
if (( $+commands[fastfetch] )); then
    alias btw=fastfetch
elif (( $+commands[neofetch] )); then
    alias btw=neofetch
fi

# eza — pretty `ls` with icons and git status
if (( $+commands[eza] )); then
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -lhg --git --icons --group-directories-first"
    # -h, -g and --git only mean anything in long format, so la carries just -a
    alias la="eza -a --icons --group-directories-first"
    alias lla="eza -lahg --git --icons --group-directories-first"
else
    # The three below expand through the ls alias above, which already carries
    # --color=auto; repeating it here would just pass the flag twice.
    alias ls="ls --color=auto"
    alias ll="ls -lh"
    alias la="ls -A"
    alias lla="ls -lAh"
fi

# ─────────────────────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────────────────────
# Runs before the tools below on purpose. nvm's bash_completion calls a full
# compinit itself when none has run yet, which happened every startup and ignored
# the caching below; going first makes its `command -v compinit` succeed so it
# skips straight to bashcompinit. fzf's completion also only installs itself when
# compdef already exists. This whole block used to live inside a block a package
# installer owned, so uninstalling that tool would have taken all completion
# with it.
# Rebuild the dump at most once a day; -C reuses it the rest of the time. Running
# the full scan every startup costs ~340ms here, but never running it is worse: the
# dump on this machine was five months stale, so grok's own completion — installed
# by the very block that set -C — had never loaded.
autoload -Uz compinit
# Glob qualifiers only fire during filename generation, and [[ ]] does not do any —
# `[[ -n $dump(N.mh+24) ]]` is just a non-empty literal, so it is always true. An
# array assignment does glob, so the age test goes there.
# mh-24 matches only a dump written in the last 24 hours, so a missing dump and a
# stale one both fall through to the full scan.
_zdump=( ${ZDOTDIR:-$HOME}/.zcompdump(N.mh-24) )
if (( $#_zdump )); then
    compinit -C
else
    compinit
fi
unset _zdump

# Without these, completion runs at bare defaults — this is what leaving oh-my-zsh
# quietly dropped. menu select needs zsh/complist, which zstyle loads on demand.
zstyle ':completion:*' menu select                         # arrow-key selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # dow<TAB> finds Downloads
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}      # reuse the palette above

# ─────────────────────────────────────────────────────────────
# Tools
# ─────────────────────────────────────────────────────────────
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# Catppuccin Mocha, the same palette starship.toml declares — see the Prompt block.
export FZF_DEFAULT_OPTS=" \
  --color=bg:#1e1e2e,bg+:#313244 \
  --color=fg:#cdd6f4,fg+:#cdd6f4 \
  --color=header:#f38ba8,hl:#f38ba8,hl+:#f38ba8 \
  --color=info:#cba6f7,marker:#b4befe \
  --color=pointer:#b4befe,prompt:#cba6f7 \
  --color=spinner:#f5e0dc"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"

# Sourcing nvm.sh costs ~190ms per shell — over a third of startup — because it
# re-activates a node version every time, not just define functions. The only part
# that matters day to day is the default version's bin on PATH, which the alias
# file names directly. It has to be a real PATH entry rather than a lazy shell
# function: mason's node-shebang tools (prettier, biome, typescript-language-server)
# are spawned by nvim as child processes, and those never see shell functions.
_nvm_default=""
[[ -r "$NVM_DIR/alias/default" ]] &&
    _nvm_default="$NVM_DIR/versions/node/$(<"$NVM_DIR/alias/default")"
if [[ -n "$_nvm_default" && -d "$_nvm_default/bin" ]]; then
    export PATH="$_nvm_default/bin:$PATH"
    # nvm itself only matters when switching versions, so pay for it on first use.
    nvm() {
        unfunction nvm
        \. "$NVM_DIR/nvm.sh"
        [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }
else
    # default points at an alias like lts/* rather than a version directory
    [[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"
fi
unset _nvm_default

[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# ─────────────────────────────────────────────────────────────
# Prompt
# ─────────────────────────────────────────────────────────────
# starship.toml (in this repo, symlinked to ~/.config/starship.toml) holds the
# format and the Catppuccin Mocha palette — including the same hex values repeated
# in FZF_DEFAULT_OPTS above, since fzf reads an env var and starship reads TOML.
# Changing theme means editing both.
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
    # starship.toml defines no right_format, so starship init's RPROMPT spawns the
    # binary a second time per prompt and renders nothing. Drop it unless a
    # right_format is added.
    RPROMPT=''
fi

# ─────────────────────────────────────────────────────────────
# Plugins — distro paths differ, so probe both.
# zsh-syntax-highlighting must be sourced last.
# ─────────────────────────────────────────────────────────────
_load_plugin() {
    local name=$1
    local p
    for p in \
        "/usr/share/zsh-$name/zsh-$name.zsh" \
        "/usr/share/zsh/plugins/zsh-$name/zsh-$name.zsh" \
        "/opt/homebrew/share/zsh-$name/zsh-$name.zsh" \
        "/usr/local/share/zsh-$name/zsh-$name.zsh"
    do
        if [[ -f "$p" ]]; then
            source "$p"
            return 0
        fi
    done
    return 1
}

# Set before sourcing: syntax-highlighting loads its highlighter files at source
# time, so brackets has to be listed by then.
#
# The length caps matter more than they look. _zsh_highlight re-runs over the whole
# buffer on every keypress, and the cost grows faster than the line: measured here
# at 0.3ms for 200 characters, 1.9ms at 2000, and 16.8ms at 8000 — enough to feel
# the keyboard drag when a long curl or base64 string is pasted. Capped, it stays
# at 0.1ms; the price is that lines past the cap go uncoloured, which costs nothing
# worth having at that length.
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_HIGHLIGHT_MAXLENGTH=512
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=512

# history alone only suggests what has already been typed; adding completion draws
# on the completion system configured above, so new commands get suggestions too.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

_load_plugin autosuggestions
_load_plugin syntax-highlighting
unset -f _load_plugin

# Machine-local overrides, sourced last so they win over everything above.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Read before /etc/zsh/zshrc, which is the point: Debian and Ubuntu run a full
# compinit there, before ~/.zshrc has had a chance to add anything to fpath. That
# cost ~340ms per shell and produced a dump missing every completion added later.
# .zshrc runs compinit itself, once, after fpath is complete.
skip_global_compinit=1

# zsh setup for macOS. install.sh adds this line to ~/.zshrc:
#   source ~/.config/zsh/init.zsh
# (On Omarchy these things are already handled by Omarchy's bash setup.)

# Homebrew: Apple Silicon lives in /opt/homebrew, Intel in /usr/local.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_brew ]] && { eval "$($_brew shellenv)"; break; }
done
unset _brew

# Tab completion (also loads completions installed by Homebrew).
if command -v brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi
autoload -Uz compinit && compinit -u
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # case-insensitive

# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# Tool versions (mise) and the Starship prompt.
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Inline suggestions. Keep this last so it sees the other widgets.
source ~/.config/zsh/autosuggestions.zsh

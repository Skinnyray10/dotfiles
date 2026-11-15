# Inline suggestions (grey ghost text) for zsh on macOS.
#
# Install once:  brew install zsh-autosuggestions
# Loaded by ~/.config/zsh/init.zsh, which install.sh adds to ~/.zshrc.

# Suggest from history first, then from normal completion.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Color of the suggestion text (grey).
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# Homebrew lives in /opt/homebrew on Apple Silicon and /usr/local on Intel.
for _zas in /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
            /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  [[ -f $_zas ]] && { source "$_zas"; break; }
done
unset _zas

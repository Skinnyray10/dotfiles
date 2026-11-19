# Terminal productivity tools, themed with Cyberpunk: Edgerunners.
# Works in bash and zsh. Sourced from ~/.bashrc (Linux) or ~/.zshrc (macOS).
# On Omarchy, fzf/zoxide/eza are already wired by Omarchy's bash setup.

# fzf colors (same palette as the terminal and Starship).
export FZF_DEFAULT_OPTS="--height=60% --layout=reverse --border=rounded --info=inline \
--color=bg:#0b0614,bg+:#2a1840,fg:#d9f6ff,fg+:#ffffff,hl:#ff2a6d,hl+:#ff5c8f \
--color=border:#b026ff,header:#6b5b8a,info:#00f0ff,pointer:#fcee0a,marker:#05ffa1 \
--color=prompt:#fcee0a,spinner:#00f0ff,label:#b026ff,query:#d9f6ff"

# fd feeds fzf: fast, respects .gitignore, includes dotfiles.
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# Previews: files with bat, folders with an eza tree.
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"

# bat uses the terminal's own ANSI colors, so it follows the palette automatically.
export BAT_THEME="ansi"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# zsh (macOS): bash gets these from Omarchy.
if [ -n "${ZSH_VERSION-}" ]; then
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
  command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
  if command -v eza >/dev/null 2>&1; then
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lt='eza --tree --level=2 --long --icons --git'
  fi
  alias ..='cd ..'
  alias ...='cd ../..'
fi

# Short aliases.
alias gs='git status -sb'
alias lg='lazygit'
alias cat='bat --paging=never --style=plain'
alias ts='tmux-sessionizer'

# mkcd: make a folder and enter it.
mkcd() { mkdir -p "$1" && cd "$1" || return; }

# Greeting: once per new terminal window, never inside tmux or scripts.
if [ -t 1 ] && [ -z "${TMUX-}" ] && [ -z "${FASTFETCH_SHOWN-}" ] && command -v fastfetch >/dev/null 2>&1; then
  export FASTFETCH_SHOWN=1
  fastfetch
fi

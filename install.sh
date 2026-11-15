#!/usr/bin/env bash
# Install these dotfiles on Omarchy/Arch Linux or macOS.
#
#   ./install.sh               install dependencies, back up conflicts, link configs
#   ./install.sh --dry-run     print what would happen, change nothing
#   ./install.sh --no-deps     skip installing packages (only back up and link)
#
# Works with the bash 3.2 that ships with macOS.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="${DOTFILES_OS:-$(uname -s)}" # DOTFILES_OS lets you test the other branch
STAMP="$(date +%s)"
DRY_RUN=0
INSTALL_DEPS=1

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --no-deps) INSTALL_DEPS=0 ;;
    -h | --help)
      sed -n '2,8p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      exit 1
      ;;
  esac
done

case "$OS" in
  Linux) PACKAGES="shared omarchy" ;;
  Darwin) PACKAGES="shared mac" ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 1
    ;;
esac

say() { printf '\n==> %s\n' "$*"; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '+ %s\n' "$*"
  else
    "$@"
  fi
}

# --- 1. Dependencies ---------------------------------------------------
install_deps_linux() {
  run sudo pacman -S --needed --noconfirm stow neovim starship wezterm lazygit git-delta
  # ble.sh (inline suggestions for bash) is not in the Arch repos or the AUR.
  if [ ! -f "$HOME/.local/share/blesh/ble.sh" ]; then
    say "Building ble.sh from source into ~/.local"
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "+ git clone ble.sh, then make install PREFIX=\$HOME/.local"
    else
      tmp="$(mktemp -d)"
      git clone -q --recursive --depth 1 --shallow-submodules \
        https://github.com/akinomyoga/ble.sh.git "$tmp/ble.sh"
      make -C "$tmp/ble.sh" install PREFIX="$HOME/.local"
      rm -rf "$tmp"
    fi
  fi
}

install_deps_mac() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required. Install it from https://brew.sh and run this again." >&2
    exit 1
  fi
  run brew install stow neovim starship lazygit git-delta zsh-autosuggestions
  run brew install --cask wezterm font-jetbrains-mono-nerd-font
}

if [ "$INSTALL_DEPS" -eq 1 ]; then
  say "Installing dependencies ($OS)"
  if [ "$OS" = "Linux" ]; then install_deps_linux; else install_deps_mac; fi
fi

# --- 2. Back up anything that would block stow ------------------------
# Move $target aside only when it would really collide with $src.
# A real folder that stow can fill (like ~/.config/lazygit) is kept, and we
# only look inside it for colliding files.
backup_path() {
  src="$1"
  target="$2"
  [ -e "$target" ] || [ -L "$target" ] || return 0
  # Already linked to this repo (a previous run): nothing to do.
  if [ "$target" -ef "$src" ]; then return 0; fi
  if [ -d "$src" ] && [ -d "$target" ] && [ ! -L "$target" ]; then
    for child in "$src"/* "$src"/.[!.]*; do
      [ -e "$child" ] || [ -L "$child" ] || continue
      backup_path "$child" "$target/$(basename "$child")"
    done
    return 0
  fi
  say "Backing up $target"
  run mv "$target" "$target.bak.$STAMP"
}

backup_conflicts() {
  pkg="$1"
  for src in "$DOTFILES/$pkg"/.config/* "$DOTFILES/$pkg"/.config/.[!.]* \
    "$DOTFILES/$pkg"/.[!.]*; do
    [ -e "$src" ] || [ -L "$src" ] || continue
    [ "$(basename "$src")" = ".config" ] && continue
    backup_path "$src" "$HOME/${src#"$DOTFILES/$pkg"/}"
  done
}

say "Checking for conflicting files"
for pkg in $PACKAGES; do backup_conflicts "$pkg"; done

# --- 3. Link the packages with stow -----------------------------------
say "Linking packages: $PACKAGES"
mkdir -p "$HOME/.config"
cd "$DOTFILES"
# shellcheck disable=SC2086 # PACKAGES is intentionally split into words
run stow -t "$HOME" $PACKAGES

# --- 4. Hook the shell snippets into the shell rc file ----------------
# Append a line to a file only if it is not already there.
ensure_line() {
  file="$1"
  line="$2"
  if [ -f "$file" ] && grep -qF -- "$line" "$file"; then return; fi
  say "Adding to $file: $line"
  if [ "$DRY_RUN" -eq 0 ]; then printf '\n%s\n' "$line" >>"$file"; fi
}

if [ "$OS" = "Darwin" ]; then
  ensure_line "$HOME/.zshrc" "source ~/.config/zsh/autosuggestions.zsh"
else
  rc="$HOME/.bashrc"
  if [ -f "$rc" ] && ! grep -qF "blesh.bash" "$rc"; then
    say "Wiring ble.sh into $rc"
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "+ insert 'source ~/.config/shell/blesh.bash' after the interactive guard, and 'blesh_attach' at the end"
    elif grep -qF '[[ $- != *i* ]] && return' "$rc"; then
      cp "$rc" "$rc.bak.$STAMP"
      awk '{ print } /^\[\[ \$- != \*i\* \]\] && return/ { print "\n# Inline suggestions (ble.sh). Must load before the rest of this file.\nsource ~/.config/shell/blesh.bash" }' \
        "$rc.bak.$STAMP" >"$rc"
      printf '\n# Attach ble.sh last (keep this at the very bottom).\nblesh_attach\n' >>"$rc"
    else
      echo "Could not find the interactive guard in $rc. Add these by hand:" >&2
      echo "  near the top:    source ~/.config/shell/blesh.bash" >&2
      echo "  at the bottom:   blesh_attach" >&2
    fi
  fi
fi

say "Done. Open a new terminal and a new Neovim to see everything."
if [ "$DRY_RUN" -eq 1 ]; then echo "(dry run: nothing was changed)"; fi

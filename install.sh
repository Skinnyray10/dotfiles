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
  # Package names live in packages/arch.txt (comments and blank lines ignored).
  pkgs="$(grep -v '^#' "$DOTFILES/packages/arch.txt" | grep -v '^$' | tr '\n' ' ')"
  # shellcheck disable=SC2086 # pkgs is intentionally split into words
  run sudo pacman -S --needed --noconfirm $pkgs
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
  run brew bundle --file="$DOTFILES/packages/Brewfile"
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
  # `local` matters: this function calls itself, and shared variables would be
  # overwritten by the inner call.
  local src="$1"
  local target="$2"
  local child
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
run mkdir -p "$HOME/.config"
# Keep ~/.config/git a real folder so stow links only the config file. Otherwise
# stow could link the whole folder into this repo, and the private config.local
# would end up inside it.
run mkdir -p "$HOME/.config/git"
cd "$DOTFILES"
# shellcheck disable=SC2086 # PACKAGES is intentionally split into words
run stow -t "$HOME" $PACKAGES

# --- 3a. Omarchy theme (Linux only) -----------------------------------
# Edgerunners is an Omarchy theme: it styles Hyprland, the bar and the lock
# screen. It is cloned (not copied here) and symlinked so its Lua files are kept.
install_omarchy_theme() {
  [ "$OS" = "Linux" ] || return 0
  command -v omarchy >/dev/null 2>&1 || return 0
  dir="$HOME/.local/share/omarchy-themes/edgerunners"
  if [ ! -d "$dir" ]; then
    say "Cloning the Edgerunners Omarchy theme"
    run mkdir -p "$(dirname "$dir")"
    run git clone --depth 1 https://github.com/Sothcheat/omarchy-edgerunners-theme.git "$dir"
  fi
  run ln -sfn "$dir" "$HOME/.config/omarchy/themes/edgerunners"
  run omarchy theme set Edgerunners
}
install_omarchy_theme

# --- 3b. Private git identity (never stored in the repo) ----------------
# The shared git config includes ~/.config/git/config.local for name and email.
setup_git_identity() {
  identity="$HOME/.config/git/config.local"
  [ -f "$identity" ] && return 0
  say "Creating $identity (your private git identity, not tracked)"
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "+ create $identity"
    return 0
  fi
  name=""
  email=""
  if [ -t 0 ]; then
    read -r -p "Git name: " name
    read -r -p "Git email: " email
  fi
  {
    echo "# Machine-specific git identity. NOT tracked in the dotfiles repo."
    echo "[user]"
    printf '\tname = %s\n\temail = %s\n' "$name" "$email"
  } >"$identity"
  if [ -z "$name" ] || [ -z "$email" ]; then
    echo "Edit $identity and fill in your name and email." >&2
  fi
}
setup_git_identity

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
  ensure_line "$HOME/.zshrc" "source ~/.config/zsh/init.zsh"
  ensure_line "$HOME/.zshrc" "source ~/.config/shell/tools.sh"
else
  ensure_line "$HOME/.bashrc" "source ~/.config/shell/tools.sh"
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

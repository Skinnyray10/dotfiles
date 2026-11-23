# dotfiles

Personal configuration for two machines: an **Omarchy** (Arch Linux + Hyprland)
desktop and a **MacBook Air** running macOS. Everything is linked into place
with [GNU Stow](https://www.gnu.org/software/stow/), so the files in this repo
are the real files and `~/.config` only holds symlinks to them.

Theme: **Cyberpunk: Edgerunners** (neon yellow, cyan and hot pink on near-black).

## Layout

Each top-level folder is a Stow *package*. Its inner paths mirror your home
directory.

| Package     | Installed on | Contents |
|-------------|--------------|----------|
| `shared/`   | both         | Neovim (LazyVim), Ghostty, Starship, lazygit, git, tmux, mise |
| `omarchy/`  | Linux only   | Hyprland overrides, the Omarchy theme, default terminal, `ble.sh` inline suggestions for bash |
| `mac/`      | macOS only   | zsh setup (completion, Starship, mise, `zsh-autosuggestions`) |
| `packages/` | -            | `arch.txt` and `Brewfile` (what `install.sh` installs), `arch-extras.txt` (reference snapshot) |
| `docs/`     | -            | personal reference notes (not linked anywhere) |

For example, `shared/.config/ghostty/config` becomes
`~/.config/ghostty/config`.

## Quick start

```sh
git clone git@github.com:Skinnyray10/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run   # preview, changes nothing
./install.sh
```

`install.sh` picks the right packages for the OS and then:

1. Installs dependencies from `packages/` (`pacman` on Arch, `brew bundle` on macOS). Skip with `--no-deps`.
2. Moves any file that would collide to `<name>.bak.<timestamp>`. It never overwrites.
3. Links the packages with `stow -t ~`.
4. Asks for your git name and email and stores them in `~/.config/git/config.local` (untracked).
5. Adds the shell snippet to `~/.bashrc` (Linux) or `~/.zshrc` (macOS), only if missing.

It is safe to run again: a second run changes nothing.

On macOS you need [Homebrew](https://brew.sh) first.

### Manual install

```sh
stow -t ~ shared omarchy   # Linux
stow -t ~ shared mac       # macOS
stow -D -t ~ mac           # remove a package's links
```

## Day-to-day

- **Edit a config** through its normal path (`~/.config/...`) or inside the repo.
  Both are the same file. Then commit and push as usual.
- **Add a new config:** put it in the right package with the same path it has in
  `~`, then run `stow -t ~ <package>`.
  Example: `~/.config/btop/btop.conf` goes to `shared/.config/btop/btop.conf`.
- **See where a link points:** `readlink -f ~/.config/ghostty`.

## Theme palette

One file holds every color: [`theme/palette.toml`](theme/palette.toml), taken from the
[Edgerunners Omarchy theme](https://github.com/Sothcheat/omarchy-edgerunners-theme).
`theme/generate.py` renders it into each app's config, so Linux and macOS match.

```sh
$EDITOR theme/palette.toml   # change a color
theme/generate.py            # regenerate the files below
theme/generate.py --check    # exit 1 if anything is out of date (good for CI)
```

Never edit the generated files. Edit the template in `theme/templates/` and add new
outputs to `theme/targets.txt`. Generated files are committed, so a fresh Mac only
needs `./install.sh` (no generator step).

| Generated file | App |
|----------------|-----|
| `shared/.config/ghostty/theme.conf` | Ghostty |
| `shared/.config/tmux/theme.conf` | tmux |
| `shared/.config/shell/colors.sh` | fzf |
| `shared/.config/starship.toml` | Starship |
| `shared/.config/lazygit/config.yml` | lazygit |
| `shared/.config/nvim/lua/config/edgerunners.lua` | Neovim |
| `shared/.config/fastfetch/config.jsonc` | fastfetch |
| `shared/.pi/agent/themes/cyberpunk.json` | pi |

### Omarchy theme (Linux)

`install.sh` clones the Edgerunners theme to `~/.local/share/omarchy-themes/edgerunners`
and applies it. It styles Hyprland, the bar and the lock screen. Terminals follow
`palette.toml`, not the Omarchy theme.

```sh
omarchy theme set Edgerunners   # apply
omarchy theme set "Tokyo Night" # go back
```

Wallpapers are **not** in the repo (the anime's art is copyrighted and this repo is
public). Put your own in `~/.config/omarchy/backgrounds/<theme-slug>/`.

## Notes

- **Neovim theme:** `lua/plugins/theme.lua` loads Omarchy's current theme when it
  exists, and falls back to the Edgerunners palette elsewhere (for example on macOS).
- **Neovim clipboard:** the tmux/SSH clipboard helper only loads on Linux.
- **Inline suggestions:** `ble.sh` on bash (built from source by `install.sh`, it is
  not in the Arch repos), `zsh-autosuggestions` on zsh. Press `Right Arrow` to accept.
- **Terminal:** `omarchy/.config/xdg-terminals.list` makes Ghostty the default
  terminal on Omarchy.
- **Hyprland:** only `bindings.lua`, `hyprland.lua` and `input.lua` are tracked.
  `monitors.lua` is machine-specific. `omarchy refresh hyprland` can overwrite
  these files, so check `git diff` afterwards.
- **macOS Option key:** Ghostty is set to treat Option as Alt on the Mac
  (`macos-option-as-alt`), so the tmux `Alt` shortcuts work.

## Never commit

This repo is public. Keep these out of it:

- Tokens and credentials (`gh` `hosts.yml`, `.env` files, `~/.claude.json`)
- SSH keys and browser profiles
- Your git identity. It lives in the untracked `~/.config/git/config.local`.
- Wallpapers you do not own.

## Status

- Omarchy: tested.
- macOS: scripts tested in a simulated home directory only. Not yet run on a real Mac.
  Not yet verified there: the zsh init, tmux's `tmux-256color` terminfo, and the Option key setting.

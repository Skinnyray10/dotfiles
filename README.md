# dotfiles

Personal configuration for two machines: an **Omarchy** (Arch Linux + Hyprland)
desktop and a **MacBook Air** running macOS. Everything is linked into place
with [GNU Stow](https://www.gnu.org/software/stow/), so the files in this repo
are the real files and `~/.config` only holds symlinks to them.

Theme: **Cyberpunk: Edgerunners** (neon yellow, cyan and hot pink on near-black).

## Layout

Each top-level folder is a Stow *package*. Its inner paths mirror your home
directory.

| Package   | Installed on | Contents |
|-----------|--------------|----------|
| `shared/` | both         | Neovim (LazyVim), WezTerm, Starship, lazygit |
| `omarchy/`| Linux only   | default terminal, `ble.sh` inline suggestions for bash |
| `mac/`    | macOS only   | `zsh-autosuggestions` setup |
| `docs/`   | -            | personal reference notes (not linked anywhere) |

For example, `shared/.config/wezterm/wezterm.lua` becomes
`~/.config/wezterm/wezterm.lua`.

## Quick start

```sh
git clone git@github.com:Skinnyray10/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run   # preview, changes nothing
./install.sh
```

`install.sh` picks the right packages for the OS and then:

1. Installs dependencies (`pacman` on Arch, Homebrew on macOS). Skip with `--no-deps`.
2. Moves any file that would collide to `<name>.bak.<timestamp>`. It never overwrites.
3. Links the packages with `stow -t ~`.
4. Adds the shell snippet to `~/.bashrc` (Linux) or `~/.zshrc` (macOS), only if missing.

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
- **See where a link points:** `readlink -f ~/.config/wezterm`.

## Notes

- **Neovim theme:** `lua/plugins/theme.lua` loads Omarchy's current theme when
  it exists and falls back to tokyonight elsewhere (for example on macOS).
- **Neovim clipboard:** the tmux/SSH clipboard helper only loads on Linux.
- **Inline suggestions:** `ble.sh` on bash (built from source by `install.sh`,
  it is not in the Arch repos), `zsh-autosuggestions` on zsh. Press `Right Arrow`
  to accept a suggestion.
- **Terminal:** `omarchy/.config/xdg-terminals.list` makes WezTerm the default
  terminal on Omarchy.

## Never commit

This repo is public. Keep these out of it:

- Tokens and credentials (`gh` `hosts.yml`, `.env` files, `~/.claude.json`)
- SSH keys and browser profiles
- Your git identity. Keep `user.name` and `user.email` in an untracked
  `~/.config/git/config.local` and load it with `[include]`.

## Status

- Omarchy: tested.
- macOS: scripts tested in a simulated home directory only. Not yet run on a real Mac.

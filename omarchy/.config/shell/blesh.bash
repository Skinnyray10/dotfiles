# Inline suggestions (grey ghost text) for bash, provided by ble.sh.
#
# Install ble.sh once (it is not in the Arch repos or the AUR):
#   git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
#   make -C ble.sh install PREFIX="$HOME/.local"
#
# Usage in ~/.bashrc:
#   1. Near the top, right after the interactive-shell guard:
#        source ~/.config/shell/blesh.bash
#   2. At the very bottom of the file:
#        blesh_attach

if [[ $- == *i* && -f $HOME/.local/share/blesh/ble.sh ]]; then
  source "$HOME/.local/share/blesh/ble.sh" --attach=none
fi

blesh_attach() {
  [[ ${BLE_VERSION-} ]] && ble-attach
}

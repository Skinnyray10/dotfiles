// Cyberpunk: Edgerunners greeting. Shown by ~/.config/shell/tools.sh.
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "type": "small",
    "color": { "1": "38;2;{{bright_yellow|rgb}}", "2": "38;2;{{bright_cyan|rgb}}" },
    "padding": { "top": 1, "left": 2, "right": 3 }
  },
  "display": {
    "separator": "  ",
    "color": { "keys": "38;2;{{violet|rgb}}", "title": "38;2;{{red|rgb}}", "output": "38;2;{{foreground|rgb}}" }
  },
  "modules": [
    "title",
    "break",
    { "type": "os",       "key": "os   " },
    { "type": "kernel",   "key": "kern " },
    { "type": "uptime",   "key": "up   " },
    { "type": "shell",    "key": "sh   " },
    { "type": "terminal", "key": "term " },
    { "type": "memory",   "key": "mem  " },
    { "type": "disk",     "key": "disk ", "folders": "/" },
    "break",
    "colors"
  ]
}

#!/usr/bin/env python3
"""Render every themed config from theme/palette.toml.

  theme/generate.py           write the generated files
  theme/generate.py --check   exit 1 if any generated file is out of date

Templates use {{name}} for a palette color and {{name|rgb}} for "r;g;b".
Plain Python 3, no dependencies (works with the python3 that ships with macOS).
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
HEX = re.compile(r"^#[0-9a-fA-F]{6}$")


def load_palette(path):
    colors = {}
    for n, line in enumerate(path.read_text().splitlines(), 1):
        line = line.strip()
        if line.startswith("#"):
            continue
        if not line:
            continue
        m = re.match(r'^(\w+)\s*=\s*"(#[0-9a-fA-F]{6})"\s*(#.*)?$', line)
        if not m:
            sys.exit(f"{path}:{n}: cannot parse: {line!r}")
        colors[m.group(1)] = m.group(2)
    return colors


def render(text, colors, name):
    def sub(m):
        key, flt = m.group(1), m.group(2)
        if key not in colors:
            sys.exit(f"{name}: unknown color {{{{{key}}}}}")
        value = colors[key]
        if flt == "rgb":
            return ";".join(str(int(value[i : i + 2], 16)) for i in (1, 3, 5))
        if flt:
            sys.exit(f"{name}: unknown filter |{flt}")
        return value

    return re.sub(r"\{\{(\w+)(?:\|(\w+))?\}\}", sub, text)


def main():
    check = "--check" in sys.argv
    colors = load_palette(ROOT / "theme" / "palette.toml")
    for k, v in colors.items():
        if not HEX.match(v):
            sys.exit(f"bad color {k}={v}")
    stale = []
    for line in (ROOT / "theme" / "targets.txt").read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        tpl, out = line.split()
        text = render((ROOT / "theme" / "templates" / tpl).read_text(), colors, tpl)
        dest = ROOT / out
        current = dest.read_text() if dest.exists() else None
        if current != text:
            stale.append(out)
            if not check:
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.write_text(text)
                print("wrote", out)
    if check and stale:
        print("out of date:", *stale, sep="\n  ")
        sys.exit(1)
    if not stale:
        print("up to date")


if __name__ == "__main__":
    main()

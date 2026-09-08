#!/usr/bin/env python3
"""Copy the theme's message bundles into preview.html.

preview.html is a static mirror of the templates, so it has no access to
Keycloak's message resolution. This reads the real .properties files and
writes them into the <script id="pv-i18n"> block, keeping the preview's
language switcher honest.

    python3 tools/sync-preview-i18n.py
"""
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
BUNDLES = ROOT / "themes/gts-theme/login/messages"
PREVIEW = ROOT / "preview.html"
START = '<script id="pv-i18n" type="application/json">'
END = "</script>"


def read_bundle(path):
    out = {}
    for line in path.read_text(encoding="ascii").splitlines():
        if not line.strip() or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        out[key.strip()] = value.strip().encode().decode("unicode_escape")
    return out


def main():
    data = {p.stem.split("_")[1]: read_bundle(p)
            for p in sorted(BUNDLES.glob("messages_*.properties"))}
    payload = json.dumps(data, ensure_ascii=False, indent=1, sort_keys=True)

    html = PREVIEW.read_text(encoding="utf-8")
    start = html.index(START) + len(START)
    end = html.index(END, start)
    PREVIEW.write_text(html[:start] + "\n" + payload + "\n" + html[end:], encoding="utf-8")
    print(f"synced {len(data)} locales, {len(data['en'])} keys -> preview.html")


if __name__ == "__main__":
    main()

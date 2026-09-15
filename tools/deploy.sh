#!/usr/bin/env bash
#
# Install the gts-theme into a native (non-Docker) Keycloak and restart it.
# Safe to run for a first-time install or as an update.
#
#   sudo tools/deploy.sh                 # install + restart
#   sudo tools/deploy.sh --no-restart    # install only
#
# Run it from a checkout of this repo on the server:
#   git clone -b v2 <repo-url> /opt/gts-theme-src
#   cd /opt/gts-theme-src && sudo tools/deploy.sh
# To update later: git pull && sudo tools/deploy.sh
#
set -euo pipefail

# ---------------------------------------------------------------------------
# The only line you normally need to change.
# ---------------------------------------------------------------------------
KC_HOME="${KC_HOME:-/opt/keycloak}"

KC_SERVICE="${KC_SERVICE:-keycloak}"   # systemd unit name
KC_USER="${KC_USER:-}"                 # blank = read it from the unit, else 'keycloak'
THEME="${THEME:-gts-theme}"

# Files that must exist, or the copy is not usable. Checked in the source and
# again in the installed tree — an incomplete copy is the failure this script
# exists to prevent.
REQUIRED=(
  "login/theme.properties"
  "login/template.ftl"
  "login/login.ftl"
  "login/resources/css/styles.css"
  "login/resources/js/script.js"
  "login/resources/img/logo.svg"
  "login/resources/img/favicon.svg"
  "login/resources/fonts/plus-jakarta-sans-latin.woff2"
  "login/messages/messages_en.properties"
)

RESTART=1
[[ "${1:-}" == "--no-restart" ]] && RESTART=0

say()  { printf '\033[1m==>\033[0m %s\n' "$*"; }
fail() { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/themes/$THEME"
DEST="$KC_HOME/themes/$THEME"

# --- 1. check the source ----------------------------------------------------
say "Source: $SRC"
[[ -d "$SRC" ]] || fail "theme not found at $SRC — run this from a checkout of the repo"
for f in "${REQUIRED[@]}"; do
  [[ -f "$SRC/$f" ]] || fail "source is incomplete, missing: $f"
done
SRC_COUNT=$(find "$SRC" -type f ! -name '.DS_Store' | wc -l | tr -d ' ')
say "Source looks complete ($SRC_COUNT files)"

# --- 2. check the target ----------------------------------------------------
[[ -d "$KC_HOME" ]] || fail "KC_HOME does not exist: $KC_HOME (edit it at the top of this script)"
mkdir -p "$KC_HOME/themes"

if [[ -z "$KC_USER" ]]; then
  KC_USER="$(systemctl show "$KC_SERVICE" -p User --value 2>/dev/null || true)"
  [[ -n "$KC_USER" ]] || KC_USER="keycloak"
fi
id "$KC_USER" >/dev/null 2>&1 || fail "service user '$KC_USER' does not exist (set KC_USER)"
say "Keycloak home: $KC_HOME   service: $KC_SERVICE   user: $KC_USER"

# --- 3. back up whatever is there today ------------------------------------
if [[ -d "$DEST" ]]; then
  BACKUP="$KC_HOME/themes/.$THEME.backup-$(date +%Y%m%d-%H%M%S).tar.gz"
  tar -czf "$BACKUP" -C "$KC_HOME/themes" "$THEME"
  say "Backed up the existing install to $BACKUP"
fi

# --- 4. install into a staging dir, then swap -------------------------------
# Copying over a live directory can leave a half-updated theme if it fails
# partway; staging + mv keeps the switch as close to atomic as possible.
STAGE="$KC_HOME/themes/.$THEME.incoming.$$"
rm -rf "$STAGE"
cp -R "$SRC" "$STAGE"
find "$STAGE" -name '.DS_Store' -delete

for f in "${REQUIRED[@]}"; do
  [[ -f "$STAGE/$f" ]] || { rm -rf "$STAGE"; fail "copy lost $f — aborting, existing theme untouched"; }
done
NEW_COUNT=$(find "$STAGE" -type f | wc -l | tr -d ' ')
[[ "$NEW_COUNT" -eq "$SRC_COUNT" ]] || { rm -rf "$STAGE"; fail "copied $NEW_COUNT of $SRC_COUNT files — aborting"; }

chown -R "$KC_USER":"$KC_USER" "$STAGE" 2>/dev/null || true
chmod -R a+rX "$STAGE"

rm -rf "$DEST"
mv "$STAGE" "$DEST"
say "Installed $NEW_COUNT files to $DEST"

# --- 5. prove the service user can actually read it -------------------------
if ! sudo -u "$KC_USER" test -r "$DEST/login/resources/css/styles.css"; then
  fail "$KC_USER cannot read styles.css — check permissions on the parent directories ($(namei -l "$DEST/login/resources/css/styles.css" 2>/dev/null | tail -3 | tr '\n' ' '))"
fi
say "Readable by $KC_USER"

# --- 6. restart -------------------------------------------------------------
if [[ "$RESTART" -eq 1 ]]; then
  say "Restarting $KC_SERVICE (production mode caches themes, so this is required)"
  systemctl restart "$KC_SERVICE"
  sleep 3
  systemctl is-active --quiet "$KC_SERVICE" \
    && say "$KC_SERVICE is running" \
    || fail "$KC_SERVICE did not come back up — check: journalctl -u $KC_SERVICE -n 50"
else
  say "Skipped restart (--no-restart). The theme will not load until you restart."
fi

cat <<EOF

Done.

Next, once per realm:
  Admin console -> Realm settings -> Themes -> Login theme -> $THEME -> Save
  Localization  -> Internationalization on, locales: en, fr, es

Then verify (expect exactly ONE stylesheet, .../login/$THEME/css/styles.css):
  curl -s '<your auth URL>' | grep -o '<link[^>]*stylesheet[^>]*>'

Browsers cache /resources/ for 30 days and the URL does not change between
theme updates — hard-refresh (Cmd/Ctrl+Shift+R) or use a private window.
EOF

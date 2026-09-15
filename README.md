# gts-theme — EXPLORE login theme for Keycloak 26.x

Login, sign-out, password and account-recovery pages for Keycloak **26.x**.
Split layout: a brand panel drawn entirely in CSS on the left, the form on the
right. Mobile-first, follows the operating system's light/dark setting.

**No bitmap assets, no web fonts, no CDN calls.** The whole theme is ~140 KB on
disk; a login page transfers roughly 35 KB of CSS + JS + the 2 KB logo.

```
themes/gts-theme/login/
├── theme.properties            parent theme, class map, locales, app version
├── template.ftl                page shell: art panel, header, alerts, footer
├── gts-commons.ftl             shared macros (password field, submit button)
├── footer.ftl                  footer of the form column
├── login.ftl                   sign in (email + password)
├── login-username.ftl          two-step sign in — step 1
├── login-password.ftl          two-step sign in — step 2
├── login-reset-password.ftl    forgot password
├── login-update-password.ftl   set a new password
├── login-otp.ftl               authenticator code
├── login-verify-email.ftl      email verification
├── login-update-profile.ftl    required profile fields
├── login-page-expired.ftl      expired sign-in
├── terms.ftl                   terms and conditions
├── logout-confirm.ftl          sign out
├── info.ftl / error.ftl        messages and errors
├── messages/                   en, fr, es (ASCII, \uXXXX escaped)
└── resources/
    ├── css/styles.css          design tokens, layout, components (~31 KB)
    ├── js/script.js            reveal password, caps lock, submit state (~3.5 KB)
    └── img/                    logo.svg, favicon.svg
```

Pages that are not overridden (WebAuthn, IdP linking, recovery codes) inherit
this template and the `kc*` classes mapped in `theme.properties`, so they pick
up the same design without their own file.

The sign-in pages deliberately render **no identity-provider buttons and no
"create an account" link** — this deployment has neither. If SSO or self
registration is switched on later, both blocks have to be added back to
`login.ftl` (and `login-username.ftl`) along with styles for
`kcFormSocialAccount*`; Keycloak will not draw them on its own.

## The brand panel

The left panel is intentionally simple and non-technical. It uses the EXPLORE
mark, one welcoming statement line (`brandTagline`), the support note
(`brandNote`), and a small frosted-glass SVG composition.

The SVG is decorative: layered translucent sheets, two soft ribbons and a check
mark. It plays a short entrance animation on load and then holds still, so the
motion feels polished without competing with the sign-in form. The animated
background glow remains slow and subtle. `prefers-reduced-motion` stops both.

On small screens the band keeps only the mark and a cropped hint of the glass
composition so the form stays first.

## Keycloak version

Built and verified against **26.0.7** (the version behind `keycloakserver:26.3.2`
in `../KeycloakServer`). Two things this theme deliberately does *not* use,
because they only exist in 26.1+:

- `passkeys.ftl` / `<@passkeys.conditionalUIData/>` — no such template in 26.0.x,
  and importing it fails the whole page with a 500. Passkey conditional UI lives
  in `login-passkeys-conditional-authenticate.ftl` there, which falls back to the
  base version.
- `authenticationSession.authSessionIdHash` — guarded with
  `(authenticationSession.authSessionIdHash)??` in `template.ftl`, so the
  cross-tab session check switches itself on if you upgrade.

Everything else the templates rely on (`password-commons.ftl`,
`user-profile-commons.ftl`, `otpLogin.*`, `url.ssoLoginInOtherTabsUrl`,
`menu-button-links.js`) exists in 26.0.x.

## Repository layout beyond the theme

```
tools/
├── deploy.sh              install on a server + restart (see below)
└── sync-preview-i18n.py   copy message bundles into preview.html
preview.html               offline preview of every page, no Keycloak needed
```

## Deploying to a server

For a native (non-Docker) Keycloak. Everything below is safe to re-run.

### One-time setup on the server

```bash
# 1. Put a checkout somewhere outside the Keycloak install
sudo git clone -b v2 <repo-url> /opt/gts-theme-src

# 2. Point the script at your Keycloak, if it is not /opt/keycloak
sudo nano /opt/gts-theme-src/tools/deploy.sh    # edit KC_HOME on line ~20
```

`KC_HOME` is the only value you normally set. The service user is read from the
systemd unit automatically; override `KC_SERVICE` or `KC_USER` at the top only
if your unit is not called `keycloak`. Find them with:

```bash
systemctl cat keycloak | grep -E 'ExecStart|User'
```

### Every deploy

```bash
cd /opt/gts-theme-src
sudo git pull
sudo tools/deploy.sh
```

The script installs the theme, fixes ownership and permissions, and restarts
Keycloak. Pass `--no-restart` to stage it without restarting.

**A restart is required.** In production mode Keycloak caches themes and
`theme.properties`, so files copied into a running server are ignored until it
restarts. It also ends active login sessions on a single node — time it
accordingly.

### Select the theme (once per realm)

Not scriptable — do it in the admin console after the first deploy:

1. **Realm settings → Themes → Login theme → `gts-theme` → Save**
2. **Realm settings → Localization → Internationalization** on, locales
   `en, fr, es` — without this the language switcher does not render.

If `gts-theme` is missing from the dropdown, Keycloak did not find
`login/theme.properties`; check the install path.

### Verify

```bash
curl -s '<auth URL>' | grep -o '<link[^>]*stylesheet[^>]*>'
```

Expect **exactly one** stylesheet ending `login/gts-theme/css/styles.css`.

- Several PatternFly files as well → the server is running an old copy that
  predates `stylesCommon=` in `theme.properties`.
- `login/keycloak/css/login.css` → the realm is still on the stock theme
  (see "Select the theme").

Then check every asset resolves. Take `<hash>` from the href above:

```bash
for f in css/styles.css js/script.js img/logo.svg img/gts.png img/favicon.svg \
         fonts/plus-jakarta-sans-latin.woff2 fonts/plus-jakarta-sans-latin-ext.woff2; do
  printf "%-46s " "$f"
  curl -s -o /dev/null -w "%{http_code}\n" "https://<host>/resources/<hash>/login/gts-theme/$f"
done
```

All seven must be `200`. Anything else means an incomplete copy — the most
common failure, and what the script's manifest check exists to prevent.

**Always hard-refresh** (Cmd/Ctrl+Shift+R or a private window). Keycloak serves
`/resources/` with `Cache-Control: max-age=2592000`, and the version hash in the
URL comes from the Keycloak version, not the theme — so it does not change when
you update the theme and browsers will happily serve a month-old file.

### Rollback

Each deploy tars the previous install first:

```bash
ls $KC_HOME/themes/.gts-theme.backup-*.tar.gz
sudo rm -rf $KC_HOME/themes/gts-theme
sudo tar -xzf $KC_HOME/themes/.gts-theme.backup-<timestamp>.tar.gz -C $KC_HOME/themes/
sudo systemctl restart keycloak
```

### Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Theme absent from the dropdown | wrong path, or no restart | `ls $KC_HOME/themes/gts-theme/login/theme.properties`, restart |
| Page loads, no styling | realm still on the stock theme | select `gts-theme` in Realm settings |
| `styles.css` → 404 | incomplete copy | re-run `deploy.sh`; it aborts rather than half-install |
| `styles.css` → 403 | Keycloak user cannot read it | `sudo -u keycloak test -r <file>`, then `namei -l <file>` |
| Design looks half-stock | `stylesCommon` inherited from the parent chain | ensure `stylesCommon=` is present in `theme.properties` |
| Old CSS after deploying | browser cache, 30-day max-age | hard-refresh |
| Fonts fall back to system | `resources/fonts/` not copied | re-run `deploy.sh` |

## Working on the theme

`../KeycloakServer/docker-compose.yml` mounts this repo into a local server:

```yaml
  keycloak:
    volumes:
      - ../Keycloak-themes/themes/gts-theme:/opt/keycloak/themes/gts-theme:ro
```

That service runs `start-dev`, which disables theme caching — edit a file here
and reload the login page, no restart needed.

Or start any Keycloak with theme caching off so edits show up on reload:

```bash
bin/kc.sh start-dev --spi-theme-cache-themes=false --spi-theme-cache-templates=false --spi-theme-static-max-age=-1
```

For visual work you don't need Keycloak at all — open `preview.html` from the
repository root. It renders every page against the theme's real `styles.css` and
`script.js`, with a page picker, a light/dark toggle and a working language
switcher. `?page=3&theme=dark&lang=fr` links to a single state.

The switcher reads the theme's own message bundles, so it shows the wording that
actually ships. After editing any `messages_*.properties`, re-sync it:

```bash
python3 tools/sync-preview-i18n.py
```

Strings Keycloak owns rather than the theme — `termsText`, field validation
messages, required-action names — stay English in the preview; the server
translates those from its own bundles at runtime.

Keep `preview.html` in step with the templates: it uses the same class names, so
a class renamed in the CSS must be renamed in both.

## Customising

- **Logo** — replace `resources/img/logo.svg`. It is rendered white over the
  brand panel via a CSS filter, so ship it as a solid single-colour mark.
- **Light / dark** — `colorScheme` in `theme.properties`: `auto` (default,
  follows the visitor's OS setting), `light` or `dark` to pin it. The value is
  written to `<html data-theme="...">`, which the CSS tokens key off.
- **Colours, spacing, radii, motion** — the token block at the top of
  `styles.css`. Light values live on `:root`; the dark overrides sit in the
  `prefers-color-scheme` block and the `[data-theme="dark"]` block right below
  it. Change both.
- **Wording** — `messages/messages_*.properties`. Anything not defined there
  falls back to Keycloak's `base` bundle. Files are ASCII with `\uXXXX`
  escapes; keep them that way to stay encoding-proof.
- **Brand panel copy** — `brandName`, `brandTagline`, `brandNote`.
- **Version label** — `appVersion` in `theme.properties`, shown in the footer.
- **Footer links** — `footer.ftl` (ships without links; add real URLs).

## Accessibility and behaviour

- Every control has a visible focus ring; targets are at least 44 px.
- Inputs are 16 px so iOS doesn't zoom on focus.
- `prefers-reduced-motion` disables the panel animation and all transitions.
- The password reveal button, caps-lock notice and submit-pending state are
  progressive enhancements — the pages work with JavaScript off.
- Errors are wired to their fields with `aria-invalid` and `aria-describedby`.

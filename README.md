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

## Install

1. Copy the `themes` folder into `$KEYCLOAK_HOME/`, so the result is
   `$KEYCLOAK_HOME/themes/gts-theme/login/...`.
2. **Realm settings → Themes → Login theme → `gts-theme` → Save**.
3. For `fr` / `es`, enable **Realm settings → Localization → Internationalization**
   and pick the supported locales.

### How it is wired here

`../KeycloakServer/docker-compose.yml` mounts this repo into the running server:

```yaml
  keycloak:
    volumes:
      - ../Keycloak-themes/themes/gts-theme:/opt/keycloak/themes/gts-theme:ro
```

The `vertex` realm has `loginTheme=gts-theme`, internationalization on, and
`en, fr, es` as supported locales. Because that service runs `start-dev`,
Keycloak disables theme caching — edit a file here and reload the login page.

For a deployable image instead of a bind mount, copy `themes/gts-theme` into the
`KeycloakServer` build context and add to the second stage of its Dockerfile:

```dockerfile
COPY themes/gts-theme /opt/keycloak/themes/gts-theme
```

## Working on the theme

Start Keycloak with theme caching off so edits show up on reload:

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

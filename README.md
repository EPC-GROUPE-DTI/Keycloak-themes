# mytheme — Thème Keycloak personnalisé

Thème custom pour Keycloak **26.x** : pages de connexion, déconnexion et
changement de mot de passe, reproduisant la maquette `login.svg` (fond photo
sombre + accent teal `#00CA9C`). Le design est **responsive**.

## Structure

```
themes/mytheme/login/
├── theme.properties            config du thème (parent, styles, scripts, locales)
├── template.ftl                coquille HTML (fond SVG, carte verte, header/footer)
├── login.ftl                   page de connexion (username + password)
├── login-username.ftl          connexion en 2 étapes — étape 1 (username)
├── login-password.ftl          connexion en 2 étapes — étape 2 (password)
├── logout-confirm.ftl          page de déconnexion
├── login-update-password.ftl   changement de mot de passe
├── info.ftl                    messages de succès / info
├── error.ftl                   page d'erreur
├── footer.ftl                  footer custom
├── messages/
│   ├── messages_en.properties
│   └── messages_fr.properties
└── resources/
    ├── css/styles.css          design complet + responsive
    ├── js/script.js            toggle afficher/masquer mot de passe
    └── img/
        ├── login-bg.svg        fond de page reconstruit (léger)
        ├── bg1.jpg bg2.jpg     décorations d'arrière-plan
        ├── main.jpg            photo principale
        ├── portrait.jpg        portrait
        └── logo.svg            dépose ton logo ici (affiché automatiquement)
```

## Installation

1. Copier le dossier `themes` dans `$KEYCLOAK_HOME/` (la structure doit être
   `$KEYCLOAK_HOME/themes/mytheme/login/...`).

2. Activer le thème dans la console d'administration :
   **Realm Settings → Themes → Login Theme → `mytheme` → Save**.

3. (Facultatif) Language dans l'URL ou config i18n du realm pour `fr` / `en`.

## Développement (sans cache)

Redémarrer Keycloak avec :

```
bin\kc.bat start --spi-theme--static-max-age=-1 --spi-theme--cache-themes=false --spi-theme--cache-templates=false
```

Puis recharger la page de connexion du realm
(`http://localhost:8080/realms/{realm}/account` ou l'URL de login du client).

> Pense à réactiver le cache (`--spi-theme--cache-themes=true` par défaut) en production.

## Personnalisation

- **Logo** : déposer `logo.svg` dans `resources/img/`. Il est affiché
  automatiquement dans le header (sinon seul le nom du realm apparaît).
- **Couleurs / formes** : variables CSS en tête de `resources/css/styles.css`
  (`--brand`, `--card-grad`, `--radius-*`, etc.).
- **Liens du footer** : modifier `footer.ftl`.
- **Textes** : clés de messages dans `messages/messages_fr.properties`
  (les messages non définis héritent du thème `base`).

## Assets sources

Les images proviennent du fichier `login.svg` original (4 PNG embarqués),
extraits puis compressés (39 Mo → ~560 Ko) pour le web. Le fond
`login-bg.svg` conserve exactement les positions, tailles et rotations de la
maquette d'origine ; les deux rectangles gris `#D9D9D9` ont été remplacés par
le vert de marque `#00CA9C`.

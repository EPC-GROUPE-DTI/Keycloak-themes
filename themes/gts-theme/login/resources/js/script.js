(function () {
  "use strict";

  var i18n = {
    en: {
      username: "Mail",
      password: "Password",
      doLogIn: "Sign in",
      doForgotPassword: "I forgot my password",
      noAccount: "You don't have an account",
      doRegister: "Sign up",
      showPassword: "Show password",
      hidePassword: "Hide password"
    },
    fr: {
      username: "Mail",
      password: "Mot de passe",
      doLogIn: "Connexion",
      doForgotPassword: "Mot de passe oubli\u00e9\u00a0?",
      noAccount: "Vous n\u2019avez pas de compte\u00a0?",
      doRegister: "S\u2019inscrire",
      showPassword: "Afficher le mot de passe",
      hidePassword: "Masquer le mot de passe"
    },
    es: {
      username: "Correo",
      password: "Contrase\u00f1a",
      doLogIn: "Conectarse",
      doForgotPassword: "Olvid\u00e9 mi contrase\u00f1a",
      noAccount: "\u00bfNo tienes cuenta?",
      doRegister: "Registrarse",
      showPassword: "Mostrar contrase\u00f1a",
      hidePassword: "Ocultar contrase\u00f1a"
    }
  };

  var langNames = { en: "English", fr: "Fran\u00e7ais", es: "Espa\u00f1ol" };

  function applyLang(lang) {
    var t = i18n[lang];
    if (!t) return;

    // text nodes
    document.querySelectorAll("[data-i18n]").forEach(function (el) {
      el.textContent = t[el.dataset.i18n] || el.textContent;
    });

    // input placeholders
    document.querySelectorAll("[data-i18n-placeholder]").forEach(function (el) {
      el.placeholder = t[el.dataset.i18nPlaceholder] || el.placeholder;
    });

    // submit value
    document.querySelectorAll("[data-i18n-value]").forEach(function (el) {
      el.value = t[el.dataset.i18nValue] || el.value;
    });

    // password toggle aria-labels
    document.querySelectorAll("[data-i18n-label-show]").forEach(function (el) {
      var show = t[el.dataset.i18nLabelShow];
      var hide = t[el.dataset.i18nLabelHide];
      if (show) el.dataset.labelShow = show;
      if (hide) el.dataset.labelHide = hide;
    });

    var localeBtn = document.getElementById("kc-current-locale-link");
    if (localeBtn) localeBtn.textContent = langNames[lang];

    localStorage.setItem("preview-lang", lang);
  }

  document.addEventListener("DOMContentLoaded", function () {
    // Locale dropdown toggle
    var localeBtn = document.getElementById("kc-current-locale-link");
    var localeList = document.getElementById("language-switch1");
    if (localeBtn && localeList) {
      localeBtn.addEventListener("click", function (e) {
        e.stopPropagation();
        var expanded = localeBtn.getAttribute("aria-expanded") === "true";
        localeBtn.setAttribute("aria-expanded", String(!expanded));
        localeList.style.display = expanded ? "" : "block";
      });
      document.addEventListener("click", function () {
        localeBtn.setAttribute("aria-expanded", "false");
        localeList.style.display = "";
      });

      // Language selection
      localeList.querySelectorAll("[data-lang]").forEach(function (link) {
        link.addEventListener("click", function (e) {
          e.preventDefault();
          applyLang(link.dataset.lang);
        });
      });
    }

    // Restore saved language
    var saved = localStorage.getItem("preview-lang");
    if (saved && i18n[saved]) applyLang(saved);

    document.querySelectorAll("[data-password-toggle]").forEach(function (button) {
      button.addEventListener("click", function () {
        var input = document.getElementById(button.getAttribute("aria-controls"));
        if (!input) {
          return;
        }

        var isVisible = input.getAttribute("type") === "text";
        input.setAttribute("type", isVisible ? "password" : "text");
        button.classList.toggle("mytheme-toggle-visible", !isVisible);

        if (button.dataset.labelShow && button.dataset.labelHide) {
          button.setAttribute("aria-label", isVisible ? button.dataset.labelShow : button.dataset.labelHide);
        }
      });
    });
  });
})();

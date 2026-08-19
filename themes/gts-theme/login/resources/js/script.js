/* =============================================================================
   XPLORE login theme — progressive enhancement only.
   Everything here is optional: the pages work with JavaScript disabled.
   The locale menu is handled by Keycloak's own menu-button-links.js.
   ============================================================================= */
(function () {
  "use strict";

  /* --- Password visibility ------------------------------------------------ */
  function bindReveal(button) {
    var input = document.getElementById(button.getAttribute("aria-controls"));
    var icon = button.querySelector("span");
    if (!input) return;

    button.hidden = false;
    button.setAttribute("aria-pressed", "false");

    button.addEventListener("click", function () {
      var shown = input.type === "text";
      input.type = shown ? "password" : "text";
      button.setAttribute("aria-pressed", String(!shown));
      button.setAttribute(
        "aria-label",
        shown ? button.dataset.labelShow : button.dataset.labelHide
      );
      if (icon) {
        icon.classList.toggle("gts-icon-eye", shown);
        icon.classList.toggle("gts-icon-eye-off", !shown);
      }
      // keep the caret where the person left it
      var end = input.value.length;
      input.focus();
      try {
        input.setSelectionRange(end, end);
      } catch (e) {
        /* number/email inputs don't allow this — harmless */
      }
    });
  }

  /* --- Caps lock notice --------------------------------------------------- */
  function bindCapsLock(input) {
    var notice = document.getElementById(input.id + "-caps");
    if (!notice) return;

    function update(event) {
      if (typeof event.getModifierState !== "function") return;
      notice.dataset.visible = String(event.getModifierState("CapsLock"));
    }

    input.addEventListener("keyup", update);
    input.addEventListener("keydown", update);
    input.addEventListener("blur", function () {
      notice.dataset.visible = "false";
    });
  }

  /* --- Submit feedback ---------------------------------------------------- */
  function bindPending(form) {
    form.addEventListener("submit", function () {
      var button = form.querySelector("[data-pending-label]");
      if (!button || button.dataset.pending === "true") return;

      // Let the value reach the server before we change the button.
      window.setTimeout(function () {
        button.dataset.pending = "true";
        button.disabled = true;
        var label = button.dataset.pendingLabel;
        if (button.tagName === "INPUT") {
          button.value = label;
        } else {
          button.textContent = label;
        }
      }, 0);
    });
  }

  function reset() {
    document.querySelectorAll("[data-pending='true']").forEach(function (button) {
      button.dataset.pending = "false";
      button.disabled = false;
      var label = button.dataset.idleLabel;
      if (!label) return;
      if (button.tagName === "INPUT") {
        button.value = label;
      } else {
        button.textContent = label;
      }
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-reveal]").forEach(bindReveal);
    document.querySelectorAll("[data-caps-lock]").forEach(bindCapsLock);
    document.querySelectorAll("form[data-pending-form]").forEach(bindPending);
  });

  // Coming back via the browser's back button must not leave a dead button.
  window.addEventListener("pageshow", function (event) {
    if (event.persisted) reset();
  });
})();

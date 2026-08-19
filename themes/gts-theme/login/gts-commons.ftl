<#--
  Shared field markup for the XPLORE theme.
  Named gts-commons so it never shadows Keycloak's own *-commons.ftl files.
-->

<#-- Password field: label (with optional inline link), reveal button, caps-lock notice.
     Nested content is rendered under the field — use it for the error message. -->
<#macro passwordField id name label autocomplete="current-password" autofocus=false invalid=false linkHref="" linkLabel="">
    <div class="${properties.kcFormGroupClass!}<#if invalid> ${properties.kcFormGroupErrorClass!}</#if>">
        <#if linkHref?has_content>
            <div class="gts-label-row">
                <label for="${id}" class="${properties.kcLabelClass!}">${label}</label>
                <a class="gts-label-link" href="${linkHref}">${linkLabel}</a>
            </div>
        <#else>
            <label for="${id}" class="${properties.kcLabelClass!}">${label}</label>
        </#if>

        <div class="${properties.kcInputGroup!}">
            <input type="password" id="${id}" name="${name}" class="${properties.kcInputClass!}"
                   autocomplete="${autocomplete}"<#if autofocus> autofocus</#if>
                   data-caps-lock
                   aria-invalid="${invalid?c}"
                   aria-describedby="${id}-caps" />
            <button type="button" hidden data-reveal
                    class="${properties.kcFormPasswordVisibilityButtonClass!}"
                    aria-controls="${id}" aria-label="${msg('showPassword')}"
                    data-label-show="${msg('showPassword')}" data-label-hide="${msg('hidePassword')}">
                <span class="${properties.kcFormPasswordVisibilityIconShow!}" aria-hidden="true"></span>
            </button>
        </div>

        <p class="gts-caps" id="${id}-caps" data-visible="false" aria-live="polite">${msg("capsLockOn")}</p>
        <#nested>
    </div>
</#macro>

<#-- Primary submit button. `pending` is what the button says once it is clicked. -->
<#macro submitButton label pending id="kc-login" name="login">
    <input type="submit" id="${id}" name="${name}"
           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
           value="${label}" data-idle-label="${label}" data-pending-label="${pending}" />
</#macro>

<#-- Field-level error message. -->
<#macro fieldError id message>
    <span id="${id}" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">${message?no_esc}</span>
</#macro>

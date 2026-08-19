<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp') subtitle=msg("otpSubtitle"); section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">
        <form id="kc-otp-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post" data-pending-form novalidate>
            <#if otpLogin.userOtpCredentials?size gt 1>
                <div class="${properties.kcFormGroupClass!}">
                    <span class="${properties.kcLabelClass!}">${msg("loginOtpDevice")}</span>
                    <ul class="gts-auth-list" id="kc-otp-credential-picker">
                        <#list otpLogin.userOtpCredentials as otpCredential>
                            <li>
                                <label class="gts-auth-item">
                                    <input id="kc-otp-credential-${otpCredential?index}" type="radio"
                                           name="selectedCredentialId" value="${otpCredential.id}"
                                           class="${properties.kcRadioInputClass!}"
                                           <#if otpCredential.id == otpLogin.selectedCredentialId>checked</#if> />
                                    <span class="gts-auth-body">
                                        <span class="gts-auth-heading">${otpCredential.userLabel}</span>
                                    </span>
                                </label>
                            </li>
                        </#list>
                    </ul>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('totp')> ${properties.kcFormGroupErrorClass!}</#if>">
                <label for="otp" class="${properties.kcLabelClass!}">${msg("loginOtpOneTime")}</label>
                <input id="otp" name="otp" type="text" class="${properties.kcInputClass!} gts-input-code"
                       autofocus autocomplete="one-time-code" inputmode="numeric" pattern="[0-9]*"
                       maxlength="8" dir="ltr" enterkeyhint="go"
                       aria-invalid="${messagesPerField.existsError('totp')?c}" />
                <#if messagesPerField.existsError('totp')>
                    <@gts.fieldError id="input-error-otp-code" message=kcSanitize(messagesPerField.get('totp')) />
                </#if>
            </div>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <@gts.submitButton label=msg("doLogIn") pending=msg("pendingVerifying") />
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

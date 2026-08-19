<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<#import "password-commons.ftl" as passwordCommons>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password','password-confirm') subtitle=msg("updatePasswordSubtitle"); section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
        <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post" data-pending-form novalidate>
            <@gts.passwordField id="password-new" name="password-new" label=msg("passwordNew")
                                autocomplete="new-password" autofocus=true
                                invalid=messagesPerField.existsError('password')>
                <#if messagesPerField.existsError('password')>
                    <@gts.fieldError id="input-error-password" message=kcSanitize(messagesPerField.get('password')) />
                </#if>
            </@gts.passwordField>

            <@gts.passwordField id="password-confirm" name="password-confirm" label=msg("passwordConfirm")
                                autocomplete="new-password"
                                invalid=messagesPerField.existsError('password-confirm')>
                <#if messagesPerField.existsError('password-confirm')>
                    <@gts.fieldError id="input-error-password-confirm" message=kcSanitize(messagesPerField.get('password-confirm')) />
                </#if>
            </@gts.passwordField>

            <div class="${properties.kcFormOptionsClass!} ${properties.kcFormSettingClass!}">
                <@passwordCommons.logoutOtherSessions/>
            </div>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <@gts.submitButton label=msg("doSubmit") pending=msg("pendingSaving") />
                <#if isAppInitiatedAction??>
                    <button type="submit" name="cancel-aia" value="true"
                            class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}">${msg("doCancel")}</button>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('password') eyebrow=msg("stepTwoOfTwo") subtitle=msg("loginPasswordSubtitle"); section>
    <#if section = "header">
        ${msg("loginPasswordTitle")}
    <#elseif section = "form">
        <form id="kc-form-login" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post" data-pending-form novalidate>
            <@gts.passwordField id="password" name="password" label=msg("password")
                                autocomplete="current-password" autofocus=true
                                invalid=messagesPerField.existsError('password')
                                linkHref=realm.resetPasswordAllowed?then(url.loginResetCredentialsUrl, '')
                                linkLabel=msg("doForgotPassword")>
                <#if messagesPerField.existsError('password')>
                    <@gts.fieldError id="input-error-password" message=kcSanitize(messagesPerField.get('password')) />
                </#if>
            </@gts.passwordField>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <@gts.submitButton label=msg("doLogIn") pending=msg("pendingSignIn") />
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

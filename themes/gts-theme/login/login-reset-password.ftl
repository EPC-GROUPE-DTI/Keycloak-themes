<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username') subtitle=realm.duplicateEmailsAllowed?then(msg("emailInstructionUsername"), msg("emailInstruction")); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post" data-pending-form novalidate>
            <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('username')> ${properties.kcFormGroupErrorClass!}</#if>">
                <label for="username" class="${properties.kcLabelClass!}"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                <input type="text" id="username" name="username" class="${properties.kcInputClass!}" autofocus dir="ltr"
                       value="<#if auth?has_content && auth.showUsername()>${auth.attemptedUsername}</#if>"
                       autocomplete="username" autocapitalize="none" autocorrect="off" spellcheck="false"
                       <#if realm.loginWithEmailAllowed>inputmode="email"</#if>
                       aria-invalid="${messagesPerField.existsError('username')?c}" />
                <#if messagesPerField.existsError('username')>
                    <@gts.fieldError id="input-error-username" message=kcSanitize(messagesPerField.get('username')) />
                </#if>
            </div>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <@gts.submitButton label=msg("doSendResetInstructions") pending=msg("pendingSending") />
            </div>
        </form>
    <#elseif section = "info">
        <a href="${url.loginUrl}">${msg("backToLogin")}</a>
    </#if>
</@layout.registrationLayout>

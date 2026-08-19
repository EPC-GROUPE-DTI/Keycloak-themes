<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username') eyebrow=msg("stepOneOfTwo") subtitle=msg("loginUsernameSubtitle"); section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
        <#if realm.password>
            <form id="kc-form-login" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post" data-pending-form novalidate>
                <#if !usernameHidden??>
                    <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('username')> ${properties.kcFormGroupErrorClass!}</#if>">
                        <label for="username" class="${properties.kcLabelClass!}"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                        <input tabindex="1" id="username" name="username" type="text" class="${properties.kcInputClass!}"
                               value="${(login.username!'')}" autofocus dir="ltr"
                               autocomplete="username"
                               autocapitalize="none" autocorrect="off" spellcheck="false"
                               <#if realm.loginWithEmailAllowed>inputmode="email"</#if>
                               aria-invalid="${messagesPerField.existsError('username')?c}"
                               <#if messagesPerField.existsError('username')>aria-describedby="input-error-username"</#if> />
                        <#if messagesPerField.existsError('username')>
                            <@gts.fieldError id="input-error-username" message=kcSanitize(messagesPerField.get('username')) />
                        </#if>
                    </div>
                </#if>

                <#if realm.rememberMe && !usernameHidden??>
                    <div class="${properties.kcFormOptionsClass!}">
                        <label class="gts-check">
                            <input id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if> />
                            <span>${msg("rememberMe")}</span>
                        </label>
                    </div>
                </#if>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <@gts.submitButton label=msg("doContinue") pending=msg("pendingDefault") />
                </div>
            </form>
        </#if>
    </#if>
</@layout.registrationLayout>

<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') subtitle=msg("loginAccountSubtitle"); section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
        <#if realm.password>
            <form id="kc-form-login" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post" data-pending-form novalidate>
                <#if !usernameHidden??>
                    <div class="${properties.kcFormGroupClass!}<#if messagesPerField.existsError('username','password')> ${properties.kcFormGroupErrorClass!}</#if>">
                        <label for="username" class="${properties.kcLabelClass!}"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                        <input tabindex="1" id="username" name="username" type="text" class="${properties.kcInputClass!}"
                               value="${(login.username!'')}" autofocus dir="ltr"
                               autocomplete="username"
                               autocapitalize="none" autocorrect="off" spellcheck="false"
                               <#if realm.loginWithEmailAllowed>inputmode="email"</#if>
                               aria-invalid="${messagesPerField.existsError('username','password')?c}"
                               <#if messagesPerField.existsError('username','password')>aria-describedby="input-error"</#if> />
                    </div>
                </#if>

                <@gts.passwordField id="password" name="password" label=msg("password")
                                    autocomplete="current-password"
                                    invalid=messagesPerField.existsError('username','password')
                                    linkHref=realm.resetPasswordAllowed?then(url.loginResetCredentialsUrl, '')
                                    linkLabel=msg("doForgotPassword")>
                    <#if messagesPerField.existsError('username','password')>
                        <@gts.fieldError id="input-error" message=kcSanitize(messagesPerField.getFirstError('username','password')) />
                    </#if>
                </@gts.passwordField>

                <#if realm.rememberMe && !usernameHidden??>
                    <div class="${properties.kcFormOptionsClass!}">
                        <label class="gts-check">
                            <input id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if> />
                            <span>${msg("rememberMe")}</span>
                        </label>
                    </div>
                </#if>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if> />
                    <@gts.submitButton label=msg("doLogIn") pending=msg("pendingSignIn") />
                </div>
            </form>
        </#if>
    </#if>
</@layout.registrationLayout>

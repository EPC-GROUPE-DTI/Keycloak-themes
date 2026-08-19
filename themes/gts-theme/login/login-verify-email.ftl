<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true subtitle=msg("emailVerifyInstruction1", user.email!''); section>
    <#if section = "header">
        ${msg("emailVerifyTitle")}
    <#elseif section = "form">
        <p class="gts-prose">${msg("emailVerifySubtitle")}</p>
        <div class="${properties.kcFormButtonsClass!}">
            <a id="resend-email" href="${url.loginAction}"
               class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}">${msg("doResendEmail")}</a>
        </div>
    <#elseif section = "info">
        <#if client?? && client.baseUrl?has_content>
            <a href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
        </#if>
    </#if>
</@layout.registrationLayout>

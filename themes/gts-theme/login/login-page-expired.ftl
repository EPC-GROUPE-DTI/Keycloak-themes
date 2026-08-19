<#import "template.ftl" as layout>
<@layout.registrationLayout subtitle=msg("pageExpiredSubtitle"); section>
    <#if section = "header">
        ${msg("pageExpiredTitle")}
    <#elseif section = "form">
        <div class="${properties.kcFormButtonsClass!}">
            <a id="loginContinueLink" href="${url.loginAction}"
               class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">${msg("doContinueSignIn")}</a>
            <a id="loginRestartLink" href="${url.loginRestartFlowUrl}"
               class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}">${msg("doStartOver")}</a>
        </div>
    </#if>
</@layout.registrationLayout>

<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${kcSanitize(msg("errorTitle"))?no_esc}
    <#elseif section = "form">
        <div id="kc-error-message">
            <p class="gts-prose">${kcSanitize(message.summary)?no_esc}</p>
            <#if !skipLink?? && client?? && client.baseUrl?has_content>
                <div class="${properties.kcFormButtonsClass!}">
                    <a id="backToApplication" href="${client.baseUrl}"
                       class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
                </div>
            </#if>
        </div>
    </#if>
</@layout.registrationLayout>

<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        <#if messageHeader??>${kcSanitize(msg("${messageHeader}"))?no_esc}<#else>${kcSanitize(message.summary)?no_esc}</#if>
    <#elseif section = "form">
        <div id="kc-info-message">
            <p class="gts-prose">${kcSanitize(message.summary)?no_esc}<#if requiredActions??><#list requiredActions>: <strong><#items as reqActionItem>${kcSanitize(msg("requiredAction.${reqActionItem}"))?no_esc}<#sep>, </#items></strong></#list></#if></p>

            <#if !skipLink??>
                <div class="${properties.kcFormButtonsClass!}">
                    <#if pageRedirectUri?has_content>
                        <a href="${pageRedirectUri}" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
                    <#elseif actionUri?has_content>
                        <a href="${actionUri}" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("proceedWithAction"))?no_esc}</a>
                    <#elseif client?? && client.baseUrl?has_content>
                        <a href="${client.baseUrl}" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
                    </#if>
                </div>
            </#if>
        </div>
    </#if>
</@layout.registrationLayout>

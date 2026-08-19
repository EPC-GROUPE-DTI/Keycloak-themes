<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<@layout.registrationLayout subtitle=msg("logoutConfirmHeader"); section>
    <#if section = "header">
        ${msg("logoutConfirmTitle")}
    <#elseif section = "form">
        <form id="kc-logout-confirm-form" class="${properties.kcFormClass!}" action="${url.logoutConfirmAction}" method="POST" data-pending-form>
            <input type="hidden" name="session_code" value="${logoutConfirm.code}" />
            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <@gts.submitButton label=msg("doLogout") pending=msg("pendingDefault") id="kc-logout" name="confirmLogout" />
                <#if !logoutConfirm.skipLink && client?? && client.baseUrl?has_content>
                    <a href="${client.baseUrl}"
                       class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

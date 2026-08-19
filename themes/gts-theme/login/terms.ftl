<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false subtitle=msg("termsSubtitle"); section>
    <#if section = "header">
        ${msg("termsTitle")}
    <#elseif section = "form">
        <div id="kc-terms-text" class="gts-terms" tabindex="0" role="region" aria-label="${msg("termsTitle")}">
            ${kcSanitize(msg("termsText"))?no_esc}
        </div>

        <form class="${properties.kcFormClass!}" action="${url.loginAction}" method="POST">
            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <input name="accept" id="kc-accept" type="submit"
                       class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                       value="${msg("doAccept")}" />
                <input name="cancel" id="kc-decline" type="submit"
                       class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}"
                       value="${msg("doDecline")}" />
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

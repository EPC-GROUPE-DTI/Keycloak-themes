<#import "template.ftl" as layout>
<#import "gts-commons.ftl" as gts>
<#import "user-profile-commons.ftl" as userProfileCommons>
<@layout.registrationLayout displayMessage=!messagesPerField.exists('global') displayRequiredFields=true subtitle=msg("loginProfileSubtitle"); section>
    <#if section = "header">
        ${msg("loginProfileTitle")}
    <#elseif section = "form">
        <form id="kc-update-profile-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post" data-pending-form>
            <@userProfileCommons.userProfileFormFields/>

            <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                <@gts.submitButton label=msg("doSubmit") pending=msg("pendingSaving") name="submitAction" />
                <#if isAppInitiatedAction??>
                    <button type="submit" name="cancel-aia" value="true"
                            class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonLargeClass!}">${msg("doCancel")}</button>
                </#if>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>

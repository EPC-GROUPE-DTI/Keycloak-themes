<#--
  Footer of the form column: the company mark that owns the product, and the
  build. Add links here if the deployment has them — each needs a real URL, so
  it ships without placeholders.
-->
<#macro content brandName="">
<footer class="gts-footer">
    <img class="gts-corp" src="${url.resourcesPath}/img/gts.png"
         width="241" height="63" alt="${msg("companyName")}" />
    <p class="gts-footer-meta">
        <span>&copy; ${.now?string('yyyy')} ${brandName}</span>
        <#if properties.appVersion?has_content>
            <span class="gts-version">${properties.appVersion}</span>
        </#if>
    </p>
</footer>
</#macro>

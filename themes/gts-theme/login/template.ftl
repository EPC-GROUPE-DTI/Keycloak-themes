<#import "footer.ftl" as loginFooter>
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false showAnotherWayIfPresent=true displayWide=false eyebrow="" subtitle="">
<#local brandName = (realm.displayName!'')?has_content?then(realm.displayName, msg("brandName"))>
<!DOCTYPE html>
<html class="${properties.kcHtmlClass!}" lang="${(locale.currentLanguageTag)!'en'}"<#if (properties.colorScheme!'auto') != 'auto'> data-theme="${properties.colorScheme}"</#if><#if (locale.rtl)!false> dir="rtl"</#if>>
<head>
    <meta charset="utf-8">
    <meta name="robots" content="noindex, nofollow">
    <meta name="color-scheme" content="light dark">
    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle", brandName)}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.svg" />
    <#if properties.stylesCommon?has_content>
        <#list properties.stylesCommon?split(' ') as style>
            <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" defer></script>
        </#list>
    </#if>
    <script type="importmap">
        {
            "imports": {
                "rfc4648": "${url.resourcesCommonPath}/vendor/rfc4648/rfc4648.js"
            }
        }
    </script>
    <script src="${url.resourcesPath}/js/menu-button-links.js" type="module"></script>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <script type="module">
        import { startSessionPolling } from "${url.resourcesPath}/js/authChecker.js";

        startSessionPolling(
            "${url.ssoLoginInOtherTabsUrl?no_esc}"
        );
    </script>
    <#-- authSessionIdHash only exists on Keycloak 26.1+; the guard keeps 26.0.x working -->
    <#if authenticationSession?? && (authenticationSession.authSessionIdHash)??>
        <script type="module">
            import { checkAuthSession } from "${url.resourcesPath}/js/authChecker.js";

            checkAuthSession(
                "${authenticationSession.authSessionIdHash}"
            );
        </script>
    </#if>
</head>

<body class="${properties.kcBodyClass!}<#if bodyClass?has_content> ${bodyClass}</#if>">
<div class="${properties.kcLoginClass!}">
    <div class="gts-stage">
        <#-- Desktop illustration, from the Explore 2 "Connexion" mockup (Figma 1937:281784).
             Coordinates are the mockup's own; the viewBox covers the column (slice) like the
             mockup frame, rocks cropped at the edges. Hidden below 60rem. -->
        <div class="gts-brand-col" aria-hidden="true">
            <svg class="gts-hero" viewBox="0 0 622.294 359.902" preserveAspectRatio="xMidYMid slice" focusable="false">
                <defs><clipPath id="gts-hero-clip"><rect width="622.294" height="359.902"/></clipPath></defs>
                <g clip-path="url(#gts-hero-clip)">
                    <image href="${url.resourcesPath}/img/hero/green-shape.svg" x="116.24" y="37.457" width="400.871" height="248.689"/>
                    <g transform="translate(278.548 349.396) rotate(-135)">
                        <svg x="-221.646" y="-229.08" width="443.291" height="458.16">
                            <image href="${url.resourcesPath}/img/hero/rock-bottom.webp" x="0" y="-7.88" width="443.291" height="443.27" preserveAspectRatio="none"/>
                        </svg>
                    </g>
                    <g transform="translate(435.676 -77.689) rotate(-174.35)">
                        <svg x="-206.991" y="-211.159" width="413.981" height="422.317">
                            <image href="${url.resourcesPath}/img/hero/rock-top.webp" x="0" y="2.069" width="413.981" height="414.0" preserveAspectRatio="none"/>
                        </svg>
                    </g>
                    <image href="${url.resourcesPath}/img/hero/gts.svg" x="463.269" y="264.768" width="50.593" height="13.183"/>
                    <image href="${url.resourcesPath}/img/hero/laptop-shadow.svg" x="96.93" y="177.41" width="334.162" height="162.788"/>
                    <image href="${url.resourcesPath}/img/hero/laptop.webp" x="154.367" y="62.395" width="325.169" height="224.189" preserveAspectRatio="xMidYMid slice"/>
                    <svg x="379.537" y="106.215" width="76.611" height="110.792">
                        <image href="${url.resourcesPath}/img/hero/phone.webp" x="0" y="-0.022" width="78.235" height="110.836" preserveAspectRatio="none"/>
                    </svg>
                </g>
            </svg>
        </div>

        <main class="${properties.kcFormCardClass!}">
            <div class="gts-card-inner">
                <div id="kc-header" class="${properties.kcHeaderClass!}">
                    <div id="kc-header-wrapper" class="${properties.kcHeaderWrapperClass!}">
                        <img class="gts-logo" src="${url.resourcesPath}/img/logo.svg" alt="${brandName}"
                             width="331" height="71" />
                    </div>
                </div>

                <#if realm.internationalizationEnabled && locale.supported?size gt 1>
                    <div class="${properties.kcLocaleMainClass!}" id="kc-locale">
                        <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                            <div id="kc-locale-dropdown" class="menu-button-links ${properties.kcLocaleDropDownClass!}">
                                <button id="kc-current-locale-link" aria-label="${msg("languages")}" aria-haspopup="true" aria-expanded="false" aria-controls="language-switch1">${locale.current}</button>
                                <ul role="menu" tabindex="-1" aria-labelledby="kc-current-locale-link" aria-activedescendant="" id="language-switch1" class="${properties.kcLocaleListClass!}">
                                    <#assign i = 1>
                                    <#list locale.supported as l>
                                        <li class="${properties.kcLocaleListItemClass!}" role="none">
                                            <a role="menuitem" id="language-${i}" class="${properties.kcLocaleItemClass!}" href="${l.url}">${l.label}</a>
                                        </li>
                                        <#assign i++>
                                    </#list>
                                </ul>
                            </div>
                        </div>
                    </div>
                </#if>

                <header class="${properties.kcFormHeaderClass!}">
                    <#if eyebrow?has_content>
                        <span class="gts-eyebrow">${eyebrow}</span>
                    </#if>
                    <h1 id="kc-page-title" class="gts-title"><#nested "header"></h1>
                    <#if subtitle?has_content>
                        <p class="gts-subtitle">${subtitle}</p>
                    </#if>
                    <#if displayRequiredFields>
                        <p class="gts-hint"><span class="required">*</span> ${msg("requiredFields")}</p>
                    </#if>
                </header>

                <#if auth?has_content && auth.showUsername() && !auth.showResetCredentials()>
                    <#nested "show-username">
                    <div id="kc-username" class="gts-identity">
                        <span class="gts-identity-name" id="kc-attempted-username">${auth.attemptedUsername}</span>
                        <a id="reset-login" href="${url.loginRestartFlowUrl}" aria-label="${msg("restartLoginTooltip")}">${msg("doChange")}</a>
                    </div>
                </#if>

                <div id="kc-content" class="${properties.kcContentWrapperClass!}">
                    <div id="kc-content-wrapper">

                        <#-- App-initiated actions should not warn about completing the action during login. -->
                        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                            <div class="${properties.kcAlertClass!} gts-alert--${message.type}" role="<#if message.type = 'error'>alert<#else>status</#if>">
                                <span class="${properties.kcFeedbackInfoIcon!}" aria-hidden="true"></span>
                                <span class="${properties.kcAlertTitleClass!}">${kcSanitize(message.summary)?no_esc}</span>
                            </div>
                        </#if>

                        <#nested "form">

                        <#if auth?has_content && auth.showTryAnotherWayLink() && showAnotherWayIfPresent>
                            <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post" class="gts-links">
                                <input type="hidden" name="tryAnotherWay" value="on"/>
                                <a href="#" id="try-another-way"
                                   onclick="document.forms['kc-select-try-another-way-form'].requestSubmit();return false;">${msg("doTryAnotherWay")}</a>
                            </form>
                        </#if>

                        <#nested "socialProviders">

                        <#if displayInfo>
                            <div id="kc-info" class="${properties.kcSignUpClass!}">
                                <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                                    <#nested "info">
                                </div>
                            </div>
                        </#if>
                    </div>
                </div>

                <@loginFooter.content brandName=brandName/>
            </div>
        </main>
    </div>
</body>
</html>
</#macro>

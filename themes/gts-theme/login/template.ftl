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
    <#-- atmosphere: brand gradient, slow drifting light, grain -->
    <div class="gts-bg" aria-hidden="true"><span></span><span></span><span></span></div>

    <div class="gts-stage">
        <div class="gts-brand-col">
                <svg class="gts-glass-art" viewBox="0 0 620 460" aria-hidden="true" focusable="false">
                  <defs>
                    <clipPath id="gts-rock-clip"><path d="M0 150H200V206H360V262H520V318H620V460H0Z"/></clipPath>
                  </defs>
                  <#-- the bench being worked -->
                  <path class="gts-rock" d="M0 150H200V206H360V262H520V318H620V460H0Z"/>
                  <path class="gts-bench" d="M0 150H200V206H360V262H520V318H620"/>
                  <#-- 1. drilling — the rig tracks the row and each hole appears behind it -->
                  <g class="gts-rig"><path d="M0 122V150" /><path d="M-7 150H7L0 162Z" /></g>
                  <g class="gts-holes">
                    <line class="gts-hole gts-hole--1" x1="40" y1="150" x2="40" y2="188" pathLength="1"/>
                    <line class="gts-hole gts-hole--2" x1="76" y1="150" x2="76" y2="188" pathLength="1"/>
                    <line class="gts-hole gts-hole--3" x1="112" y1="150" x2="112" y2="188" pathLength="1"/>
                    <line class="gts-hole gts-hole--4" x1="148" y1="150" x2="148" y2="188" pathLength="1"/>
                    <line class="gts-hole gts-hole--5" x1="184" y1="150" x2="184" y2="188" pathLength="1"/>
                  </g>
                  <#-- 2. loading — each hole charges from the toe up -->
                  <g class="gts-charges">
                    <line class="gts-charge gts-charge--1" x1="40" y1="188" x2="40" y2="158" pathLength="1"/>
                    <line class="gts-charge gts-charge--2" x1="76" y1="188" x2="76" y2="158" pathLength="1"/>
                    <line class="gts-charge gts-charge--3" x1="112" y1="188" x2="112" y2="158" pathLength="1"/>
                    <line class="gts-charge gts-charge--4" x1="148" y1="188" x2="148" y2="158" pathLength="1"/>
                    <line class="gts-charge gts-charge--5" x1="184" y1="188" x2="184" y2="158" pathLength="1"/>
                  </g>
                  <#-- 3. firing — collars flash on the delay sequence -->
                  <g class="gts-fires">
                    <circle class="gts-fire gts-fire--1" cx="40" cy="150" r="8"/>
                    <circle class="gts-fire gts-fire--2" cx="76" cy="150" r="8"/>
                    <circle class="gts-fire gts-fire--3" cx="112" cy="150" r="8"/>
                    <circle class="gts-fire gts-fire--4" cx="148" cy="150" r="8"/>
                    <circle class="gts-fire gts-fire--5" cx="184" cy="150" r="8"/>
                  </g>
                  <#-- 4. the wavefront, travelling through rock -->
                  <g clip-path="url(#gts-rock-clip)">
                    <circle class="gts-wave gts-wave--1" cx="112" cy="168" r="140"/>
                    <circle class="gts-wave gts-wave--2" cx="112" cy="168" r="140"/>
                    <circle class="gts-wave gts-wave--3" cx="112" cy="168" r="140"/>
                  </g>
                  <#-- 5. monitors on the benches trip in order of distance -->
                  <g class="gts-sensors">
                    <line class="gts-mast" x1="300" y1="206" x2="300" y2="186"/>
                    <circle class="gts-ping gts-ping--1" cx="300" cy="184" r="10"/>
                    <circle class="gts-sensor gts-sensor--1" cx="300" cy="184" r="4.5"/>
                    <line class="gts-mast" x1="430" y1="262" x2="430" y2="242"/>
                    <circle class="gts-ping gts-ping--2" cx="430" cy="240" r="10"/>
                    <circle class="gts-sensor gts-sensor--2" cx="430" cy="240" r="4.5"/>
                    <line class="gts-mast" x1="560" y1="318" x2="560" y2="298"/>
                    <circle class="gts-ping gts-ping--3" cx="560" cy="296" r="10"/>
                    <circle class="gts-sensor gts-sensor--3" cx="560" cy="296" r="4.5"/>
                  </g>
                  <#-- 6. the record, always running -->
                  <g class="gts-tape">
                    <line class="gts-baseline" x1="0" y1="404" x2="620" y2="404"/>
                    <g class="gts-scroll">
                      <path class="gts-trace" transform="translate(0 404)" d="M0 -0.2 L10 0.2 L20 1.7 L30 -0.1 L40 0.0 L50 0.3 L60 -1.3 L70 0.0 L80 0.5 L90 1.2 L100 -1.6 L110 -0.8 L120 -1.6 L130 1.2 L140 0.8 L150 -1.8 L160 1.9 L170 1.9 L180 0.6 L190 0.5 L200 -1.4 L210 -1.9 L220 0.1 L230 -1.8 L240 -1.2 L250 17.1 L260 -12.1 L270 13.4 L280 -10.9 L290 11.2 L300 -7.8 L310 6.9 L320 -5.2 L330 4.7 L340 -3.5 L350 2.6 L360 -3.1 L370 2.6 L380 -2.0 L390 1.5 L400 -1.0 L410 -1.1 L420 -0.8 L430 -1.7 L440 1.1 L450 -0.4 L460 1.4 L470 -0.5 L480 1.8 L490 1.4 L500 -2.0 L510 -1.2 L520 1.6 L530 -0.1 L540 1.9 L550 -0.4 L560 -1.7 L570 0.5 L580 1.1 L590 -0.9 L600 -1.7 L610 -0.7 L620 1.9"/>
                      <path class="gts-trace" transform="translate(620 404)" d="M0 -0.2 L10 0.2 L20 1.7 L30 -0.1 L40 0.0 L50 0.3 L60 -1.3 L70 0.0 L80 0.5 L90 1.2 L100 -1.6 L110 -0.8 L120 -1.6 L130 1.2 L140 0.8 L150 -1.8 L160 1.9 L170 1.9 L180 0.6 L190 0.5 L200 -1.4 L210 -1.9 L220 0.1 L230 -1.8 L240 -1.2 L250 17.1 L260 -12.1 L270 13.4 L280 -10.9 L290 11.2 L300 -7.8 L310 6.9 L320 -5.2 L330 4.7 L340 -3.5 L350 2.6 L360 -3.1 L370 2.6 L380 -2.0 L390 1.5 L400 -1.0 L410 -1.1 L420 -0.8 L430 -1.7 L440 1.1 L450 -0.4 L460 1.4 L470 -0.5 L480 1.8 L490 1.4 L500 -2.0 L510 -1.2 L520 1.6 L530 -0.1 L540 1.9 L550 -0.4 L560 -1.7 L570 0.5 L580 1.1 L590 -0.9 L600 -1.7 L610 -0.7 L620 1.9"/>
                    </g>
                  </g>
                </svg>
            <div id="kc-header" class="${properties.kcHeaderClass!}">
                <div id="kc-header-wrapper" class="${properties.kcHeaderWrapperClass!}">
                    <img class="gts-logo" src="${url.resourcesPath}/img/logo.svg" alt="${brandName}"
                         width="331" height="71" onerror="this.style.display='none'" />
                </div>
            </div>
            <p class="gts-aside-line">${msg("brandTagline")}</p>
            <p class="gts-aside-note">${msg("brandNote")}</p>
        </div>

        <main class="${properties.kcFormCardClass!}">
            <div class="gts-card-inner">

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

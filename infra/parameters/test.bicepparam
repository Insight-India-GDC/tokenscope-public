// ── TokenScope — VNet-integrated TEST parameters ─────────────────────────

using '../main.bicep'

// ── Environment ──────────────────────────────────────────────────────────
// env='dev' selects the DEV-sized TokenScope profile.
//
// TEST isolation comes from:
// - GitHub Environment: test
// - Separate TEST Resource Group
// - Parameter file: test.bicepparam
// - Unique projectName: tokenscopeigdctest
// - Separate TEST deployment identity
// - Separate TEST VNet
// - Separate TEST ACR
// - Separate TEST Container Apps environment
// - Separate TEST Front Door
// - Separate TEST private runner

param env = 'dev'
param location = 'westeurope'
param projectName = 'tokenscopeigdctest'

// Initial bootstrap uses latest.
// After the image workflow succeeds, the Container App should be updated
// using the immutable Git commit SHA.

param imageTag = 'latest'

param deployRbac = true

// ── Required secrets ─────────────────────────────────────────────────────
// Values come from:
//
// GitHub Repository
// → Settings
// → Environments
// → test
// → Environment secrets

param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')

param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')

param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')

// IMPORTANT:
// ENTRA_CLIENT_SECRET must be the SECRET VALUE belonging to the Entra
// App Registration specified by entraIdClientId.
//
// Do NOT use:
// - Secret ID
// - GitHub deployment identity secret
// - Secret from another Entra application

param entraIdClientSecret = readEnvironmentVariable('ENTRA_CLIENT_SECRET')

// ── Optional provider credentials ────────────────────────────────────────

param anthropicApiKey = readEnvironmentVariable(
  'ANTHROPIC_API_KEY',
  ''
)

param githubPatPartnerDemo = readEnvironmentVariable(
  'GH_PAT_PARTNER_DEMO',
  readEnvironmentVariable('GITHUB_PAT_PARTNER_DEMO', '')
)

param githubPatProduction = readEnvironmentVariable(
  'GH_PAT_PRODUCTION',
  readEnvironmentVariable('GITHUB_PAT_PRODUCTION', '')
)

param githubPatApacNfr = readEnvironmentVariable(
  'GH_PAT_ENTERPRISE_NFR',
  readEnvironmentVariable('GITHUB_PAT_APAC_NFR', '')
)

param githubAppKeyPartnerDemo = readEnvironmentVariable(
  'GH_APP_KEY_PARTNER_DEMO',
  readEnvironmentVariable('GITHUB_APP_KEY_PARTNER_DEMO', '')
)

// ── Public entry point ───────────────────────────────────────────────────
//
// FIRST TEST DEPLOYMENT:
//
// There is no TEST Front Door endpoint yet.
// Keep this empty.
//
// After Front Door is created, this will become:
//
// https://<TEST-FRONT-DOOR-HOSTNAME>

param appPublicOrigin = ''

// ── Microsoft Entra ID authentication ───────────────────────────────────
//
// This is the TokenScope HUMAN USER sign-in application.
//
// IMPORTANT:
// This is NOT tokenscope-github-test-deployer.
//
// tokenscope-github-test-deployer
//     → GitHub Actions → Azure deployment
//
// entraIdClientId below
//     → Human users → Microsoft login → TokenScope

param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'

param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'

// FIRST TEST DEPLOYMENT:
//
// Keep empty until TEST Front Door exists.
//
// Final value will become:
//
// https://<TEST-FRONT-DOOR-HOSTNAME>/auth/entra/callback

param entraIdRedirectUri = ''

param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'

param allowPersonaOverride = false

// ── Scheduled workers ────────────────────────────────────────────────────
//
// FIRST TEST DEPLOYMENT:
//
// Keep empty because TEST Front Door does not exist yet.
//
// Final value:
//
// https://<TEST-FRONT-DOOR-HOSTNAME>

param workerBaseUrl = ''

// ── Private networking ───────────────────────────────────────────────────

param enablePrivateNetworking = true

// Empty means the template generates the VNet name from:
// projectName + env/profile + region.

param vnetName = ''

// ── TEST VNet Addressing ─────────────────────────────────────────────────
//
// IMPORTANT:
//
// These must NOT overlap with DEV or DEMO if environments may eventually
// communicate through hub/spoke networking.
//
// Example:
//
// DEV  = 10.0.0.0/24
// DEMO = 10.0.1.0/24
//
// Below uses 10.0.2.0/24 as the TEST example.
//
// Confirm this range with your network/IPAM team before production use.

param vnetAddressSpace = '10.0.2.0/24'

// Container Apps infrastructure subnet

param containerAppsSubnetPrefix = '10.0.2.0/27'

// Private Endpoints subnet

param privateEndpointsSubnetPrefix = '10.0.2.32/28'

// Azure Monitor Private Link / AMPLS subnet

param amplsSubnetPrefix = '10.0.2.48/28'

// ── GitHub private runner subnet ─────────────────────────────────────────
//
// Dedicated subnet for:
//
// vm-tokenscope-test-github-runner
//
// Mirrors the successful DEV runner design.
//
// 10.0.2.64/27 provides a separate runner subnet.

param buildSubnetPrefix = '10.0.2.64/27'

// Create/link supported Azure Private DNS zone groups.

param registerDnsZoneGroups = true

// Keep Azure Monitor query access public initially.
//
// Switch to private-only only after AMPLS and all required Azure Monitor
// Private DNS configuration has been validated.

param monitorQueryPrivateOnly = false

// ── Optional landing-zone networking ────────────────────────────────────
//
// Uncomment only if the customer provides these shared resources
// and the TEST deployment identity has permission to use them.

// param natGatewayId = '/subscriptions/<subscription-id>/resourceGroups/<network-resource-group>/providers/Microsoft.Network/natGateways/<nat-gateway>'

// param subnetRouteTableId = '/subscriptions/<subscription-id>/resourceGroups/<network-resource-group>/providers/Microsoft.Network/routeTables/<route-table>'

// param subnetNetworkSecurityGroupId = '/subscriptions/<subscription-id>/resourceGroups/<network-resource-group>/providers/Microsoft.Network/networkSecurityGroups/<nsg>'

// ── Optional hub connectivity ────────────────────────────────────────────
//
// Uncomment only when TEST must connect to an approved hub VNet.

// param hubVnetId = '/subscriptions/<subscription-id>/resourceGroups/<hub-resource-group>/providers/Microsoft.Network/virtualNetworks/<hub-vnet>'

// param useRemoteGateways = true

// ── Azure Front Door Premium ─────────────────────────────────────────────
//
// VERY IMPORTANT:
//
// FIRST TEST DEPLOYMENT:
//
// Front Door MUST remain disabled.
//
// Deployment sequence:
//
// 1. Deploy private infrastructure.
// 2. Create TEST ACR.
// 3. Assign AcrPush/AcrPull.
// 4. Create TEST private runner.
// 5. Push TokenScope image.
// 6. Confirm Container App is Healthy.
// 7. Enable Front Door.
// 8. Deploy again.
// 9. Approve Front Door Private Link.
// 10. Obtain TEST Front Door URL and ID.
// 11. Update this file.
// 12. Add TEST Entra callback.
// 13. Run final TEST deployment.

param enableFrontDoor = true

param frontDoorSku = 'Premium'

// Empty during the first Front Door deployment.
//
// After Front Door is created:
//
// param frontDoorId = '<TEST-FRONT-DOOR-ID>'

param frontDoorId = ''

// Keep WAF managed rules in Log during initial TEST validation.
//
// Move to Block only after testing legitimate application traffic
// and obtaining the required security approval.

param frontDoorWafManagedRuleAction = 'Log'

// ── Monitoring ───────────────────────────────────────────────────────────

// Uncomment only when Microsoft.Monitor cannot be registered
// or customer policy explicitly requires disabling it.

// param deployAzureMonitorWorkspace = false

// Optional TEST alert destination.

// param alertNotificationEmail = '<TEST-ALERT-EMAIL>'

// Optional Anthropic reconciliation endpoint.
//
// Requires ANTHROPIC_API_KEY in GitHub TEST Environment Secrets.

// param anthropicApiEndpoint = 'https://api.anthropic.com'

// ── Key Vault recovery ───────────────────────────────────────────────────

param keyVaultCreateMode = 'default'

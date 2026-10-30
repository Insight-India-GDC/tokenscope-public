// ── TokenScope — VNet-integrated DEV parameters ──────────────────────────

using '../main.bicep'

// ── Environment ──────────────────────────────────────────────────────────

param env = 'dev'
param location = 'westeurope'
param projectName = 'tokenscopeigdc'
param imageTag = 'latest'

param deployRbac = true

// ── Secrets ──────────────────────────────────────────────────────────────

param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')
param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')
param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')
param entraIdClientSecret = readEnvironmentVariable('ENTRA_CLIENT_SECRET')

// Optional provider credentials

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

param appPublicOrigin = 'https://ep-tokenscopeigdc-dev-weu-chh4hycshyh0g2dp.a03.azurefd.net'

// ── Entra ID OIDC ────────────────────────────────────────────────────────
// Use values from the tokenscope-dev-user-login App Registration.
// Do not use the GitHub deployment application's client ID here.

param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'
param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'

param entraIdRedirectUri = 'https://ep-tokenscopeigdc-dev-weu-chh4hycshyh0g2dp.a03.azurefd.net/auth/entra/callback'

param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'
param allowPersonaOverride = false

// ── Scheduled workers ────────────────────────────────────────────────────

param workerBaseUrl = 'https://ep-tokenscopeigdc-dev-weu-chh4hycshyh0g2dp.a03.azurefd.net'

// ── Private networking ───────────────────────────────────────────────────

param enablePrivateNetworking = true

param vnetName = ''
param vnetAddressSpace = '10.0.0.0/24'

param containerAppsSubnetPrefix = '10.0.0.0/27'
param privateEndpointsSubnetPrefix = '10.0.0.32/28'
param amplsSubnetPrefix = '10.0.0.48/28'

// Leave empty until a self-hosted runner or ACR agent-pool subnet is required.

// Shared private GitHub Actions runner subnet.
// The networking module will create snet-build.

param buildSubnetPrefix = '10.0.0.64/27'

// The template manages Private DNS zone groups for Key Vault,
// PostgreSQL, Redis and ACR.

param registerDnsZoneGroups = true

// Keep Log Analytics query access public until AMPLS DNS is configured.

param monitorQueryPrivateOnly = false

// Optional landing-zone networking values.
// Uncomment only when the corresponding resource IDs are provided.

// param natGatewayId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/natGateways/<nat-gateway>'
// param subnetRouteTableId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/routeTables/<route-table>'
// param subnetNetworkSecurityGroupId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/networkSecurityGroups/<nsg>'

// Optional hub connectivity.

// param hubVnetId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<hub-vnet>'
// param useRemoteGateways = true

// ── Azure Front Door Premium ─────────────────────────────────────────────

param enableFrontDoor = true
param frontDoorSku = 'Premium'

// Front Door instance ID returned by the first successful deployment.

param frontDoorId = '2a519381-32ba-4d71-9395-f69a3306dade'

// Keep WAF managed rules in Log mode during validation.
// Move to Block only after reviewing legitimate application traffic.

param frontDoorWafManagedRuleAction = 'Log'

// ── Monitoring ───────────────────────────────────────────────────────────

// Uncomment only if Microsoft.Monitor cannot be registered.

// param deployAzureMonitorWorkspace = false

// Optional alert email.

// param alertNotificationEmail = 'manideep.muddagowni@insight.com'

// Optional Anthropic reconciliation endpoint.
// Requires ANTHROPIC_API_KEY.

// param anthropicApiEndpoint = 'https://api.anthropic.com'

// ── Key Vault recovery ───────────────────────────────────────────────────

param keyVaultCreateMode = 'default'

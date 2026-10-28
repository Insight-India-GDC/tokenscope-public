// ── TokenScope — VNet-integrated DEMO parameters ─────────────────────────

using '../main.bicep'

// ── Environment ──────────────────────────────────────────────────────────
// env='dev' selects DEV-sized Azure resources.
// DEMO isolation comes from the separate resource group, GitHub environment,
// parameter file, and unique projectName.

param env = 'dev'
param location = 'westeurope'
param projectName = 'tokenscopeigdcdemo'
param imageTag = 'latest'

param deployRbac = true

// ── Secrets ──────────────────────────────────────────────────────────────
// Values are supplied by the GitHub "demo" Environment Secrets.

param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')

param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')

param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')

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
// Empty during the initial deployment because the DEMO Front Door endpoint
// has not been created yet.

param appPublicOrigin = ''

// ── Microsoft Entra ID authentication ───────────────────────────────────
// Reuse the approved TokenScope user sign-in App Registration.
// ENTRA_CLIENT_SECRET must belong to this Client ID.

param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'
param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'

// Updated after the DEMO Front Door endpoint is created.

param entraIdRedirectUri = ''

param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'
param allowPersonaOverride = false

// ── Scheduled workers ────────────────────────────────────────────────────
// Updated to the DEMO Front Door endpoint during the final deployment pass.

param workerBaseUrl = ''

// ── Private networking ───────────────────────────────────────────────────

param enablePrivateNetworking = true

// Empty means the template generates the VNet name from projectName,
// env, and region.

param vnetName = ''

// These ranges are separate Azure resources but overlap with DEV.
// This is acceptable while the VNets remain isolated.
// Use a different range if DEMO will be peered with DEV or a shared hub.

param vnetAddressSpace = '10.0.1.0/24'
param containerAppsSubnetPrefix = '10.0.1.0/27'
param privateEndpointsSubnetPrefix = '10.0.1.32/28'
param amplsSubnetPrefix = '10.0.1.48/28'

// Optional build subnet for a self-hosted runner or ACR Tasks agent pool.
// Leave empty for the initial deployment unless private image building
// has already been designed.

param buildSubnetPrefix = ''

// Create and link Private DNS zone groups for supported Private Endpoints.

param registerDnsZoneGroups = true

// Keep Log Analytics query access public until Azure Monitor Private Link
// and its required Private DNS zones are configured.

param monitorQueryPrivateOnly = false

// ── Optional landing-zone networking ────────────────────────────────────
// Uncomment only when these Azure resources are available.

// param natGatewayId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/natGateways/<nat-gateway>'

// param subnetRouteTableId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/routeTables/<route-table>'

// param subnetNetworkSecurityGroupId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/networkSecurityGroups/<nsg>'

// ── Optional hub connectivity ────────────────────────────────────────────

// param hubVnetId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<hub-vnet>'

// param useRemoteGateways = true

// ── Azure Front Door ─────────────────────────────────────────────────────
// INITIAL DEPLOYMENT:
// Keep Front Door disabled while creating the private infrastructure and
// pushing tokenscope:latest into the new DEMO ACR.

param enableFrontDoor = true

// Premium will be used during the Front Door deployment pass.

param frontDoorSku = 'Premium'

// Generated after Front Door is created.

param frontDoorId = ''

// Keep managed WAF rules in Log mode during initial validation.

param frontDoorWafManagedRuleAction = 'Log'

// ── Monitoring ───────────────────────────────────────────────────────────

// Uncomment only if Microsoft.Monitor cannot be registered.

// param deployAzureMonitorWorkspace = false

// Optional alert notification address.

// param alertNotificationEmail = 'manideep.muddagowni@insight.com'

// Optional Anthropic reconciliation endpoint.
// Requires ANTHROPIC_API_KEY in GitHub demo Environment Secrets.

// param anthropicApiEndpoint = 'https://api.anthropic.com'

// ── Key Vault recovery ───────────────────────────────────────────────────

param keyVaultCreateMode = 'default'

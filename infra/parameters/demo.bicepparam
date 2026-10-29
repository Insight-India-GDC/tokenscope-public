// ── TokenScope — VNet-integrated DEMO parameters ─────────────────────────

using '../main.bicep'

// ── Environment ──────────────────────────────────────────────────────────
// env='dev' selects the DEV-sized TokenScope profile.
// DEMO remains isolated through:
// - GitHub Environment: demo
// - Resource Group: rg-westeurope-t1-amd-demo-helios-001
// - Parameter file: demo.bicepparam
// - Unique projectName: tokenscopeigdcdemo

param env = 'dev'
param location = 'westeurope'
param projectName = 'tokenscopeigdcdemo'

// Keep latest if the image workflow always updates the Container App
// with an immutable commit-specific image after infrastructure deployment.
param imageTag = 'latest'

param deployRbac = true

// ── Required secrets ─────────────────────────────────────────────────────
// These values come from:
// GitHub Repository → Settings → Environments → demo → Environment secrets

param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')

param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')

param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')

// This must be the Client Secret VALUE created in the Entra App whose
// Client ID is 1d51bb60-1d9b-4d5b-8bbb-6096d583d4af.
// Do not use the Secret ID.

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

param appPublicOrigin = 'https://ep-tokenscopeigdcdemo-dev-weu-d0c2adg4hqcrgfcb.a03.azurefd.net'

// ── Microsoft Entra ID authentication ───────────────────────────────────
// This is the TokenScope user sign-in application.
// It is separate from the GitHub deployment identity.

param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'
param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'

param entraIdRedirectUri = 'https://ep-tokenscopeigdcdemo-dev-weu-d0c2adg4hqcrgfcb.a03.azurefd.net/auth/entra/callback'

param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'
param allowPersonaOverride = false

// ── Scheduled workers ────────────────────────────────────────────────────

param workerBaseUrl = 'https://ep-tokenscopeigdcdemo-dev-weu-d0c2adg4hqcrgfcb.a03.azurefd.net'

// ── Private networking ───────────────────────────────────────────────────

param enablePrivateNetworking = true

// Empty means the template generates the VNet name.

param vnetName = ''

// DEMO uses a different CIDR from DEV.
// This avoids overlap if the environments are later peered.

param vnetAddressSpace = '10.0.1.0/24'

param containerAppsSubnetPrefix = '10.0.1.0/27'
param privateEndpointsSubnetPrefix = '10.0.1.32/28'
param amplsSubnetPrefix = '10.0.1.48/28'

// Leave empty unless a self-hosted runner or private ACR build agent
// is deployed inside the VNet.

param buildSubnetPrefix = ''

// Register and connect the Private DNS zone groups managed by the template.

param registerDnsZoneGroups = true

// Keep Azure Monitor query access public until AMPLS and the required
// Private DNS configuration are fully validated.

param monitorQueryPrivateOnly = false

// ── Optional landing-zone networking ────────────────────────────────────
// Uncomment only when the corresponding Azure resource IDs are available.

// param natGatewayId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/natGateways/<nat-gateway>'

// param subnetRouteTableId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/routeTables/<route-table>'

// param subnetNetworkSecurityGroupId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/networkSecurityGroups/<nsg>'

// ── Optional hub connectivity ────────────────────────────────────────────

// param hubVnetId = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<hub-vnet>'

// param useRemoteGateways = true

// ── Azure Front Door Premium ─────────────────────────────────────────────

param enableFrontDoor = true
param frontDoorSku = 'Premium'

param frontDoorId = '8d75f4f6-fb93-4225-87f1-e7abb74e31ee'

// Keep managed WAF rules in Log mode during validation.
// Change to Block only after reviewing legitimate application traffic.

param frontDoorWafManagedRuleAction = 'Log'

// ── Monitoring ───────────────────────────────────────────────────────────

// Uncomment only if Microsoft.Monitor cannot be registered.

// param deployAzureMonitorWorkspace = false

// Optional alert email.

// param alertNotificationEmail = 'manideep.muddagowni@insight.com'

// Optional Anthropic reconciliation endpoint.
// Requires ANTHROPIC_API_KEY in GitHub demo Environment Secrets.

// param anthropicApiEndpoint = 'https://api.anthropic.com'

// ── Key Vault recovery ───────────────────────────────────────────────────

param keyVaultCreateMode = 'default'

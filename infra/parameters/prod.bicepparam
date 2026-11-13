
using '../main.bicep'

// GitHub Environment: prod
// Bicep environment: production

param env = 'production'
param location = 'westeurope'
param projectName = 'tokenscopeigdcprod'

// Immutable Docker image tag from the selected Git commit.
param imageTag = readEnvironmentVariable('IMAGE_TAG', 'latest')

param deployRbac = true

// ============================================================
// PROD secrets
// ============================================================

param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')

param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')

param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')

param entraIdClientSecret = readEnvironmentVariable('ENTRA_CLIENT_SECRET')

// ============================================================
// Optional provider credentials
// ============================================================

param anthropicApiKey = readEnvironmentVariable('ANTHROPIC_API_KEY', '')

param githubPatPartnerDemo = readEnvironmentVariable('GH_PAT_PARTNER_DEMO', '')

param githubPatProduction = readEnvironmentVariable('GH_PAT_PRODUCTION', '')

param githubPatApacNfr = readEnvironmentVariable('GH_PAT_ENTERPRISE_NFR', '')

param githubAppKeyPartnerDemo = readEnvironmentVariable('GH_APP_KEY_PARTNER_DEMO', '')

// ============================================================
// Microsoft Entra user authentication
// ============================================================

param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'

param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'

param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'

param allowPersonaOverride = false

// ============================================================
// Azure Front Door public URLs
//
// Phase OFF:
//   Leave public URL variables empty.
//
// Phase CREATE:
//   Enable Front Door and establish its endpoint.
//
// Phase FINALIZE:
//   Populate these variables with the real PROD URL.
//
// Example:
// APP_PUBLIC_ORIGIN=https://your-prod-endpoint.azurefd.net
// WORKER_BASE_URL=https://your-prod-endpoint.azurefd.net
// ENTRA_REDIRECT_URI=https://your-prod-endpoint.azurefd.net/auth/entra/callback
// ============================================================

param appPublicOrigin = readEnvironmentVariable('APP_PUBLIC_ORIGIN', '')

param entraIdRedirectUri = readEnvironmentVariable('ENTRA_REDIRECT_URI', '')

param workerBaseUrl = readEnvironmentVariable('WORKER_BASE_URL', '')

// ============================================================
// PROD private networking
// ============================================================

param enablePrivateNetworking = true

param vnetName = 'vnet-tokenscopeigdc-prod-weu'

// WARNING:
// These CIDRs currently overlap with your TEST configuration.
// Obtain PROD-approved, non-overlapping ranges before creation.
// Do not renumber an existing VNet without planning the migration.

param vnetAddressSpace = '10.0.2.0/24'

param containerAppsSubnetPrefix = '10.0.2.0/27'

param privateEndpointsSubnetPrefix = '10.0.2.32/28'

param amplsSubnetPrefix = '10.0.2.48/28'

param buildSubnetPrefix = '10.0.2.64/27'

param registerDnsZoneGroups = true

param monitorQueryPrivateOnly = false

// ============================================================
// Azure Front Door Premium
// ============================================================

// Overridden by workflow front_door_phase.
param enableFrontDoor = false

param frontDoorSku = 'Premium'

// Initially empty until the Front Door identifier is available.
param frontDoorId = readEnvironmentVariable('FRONT_DOOR_ID', '')

param frontDoorWafManagedRuleAction = 'Log'

// ============================================================
// Key Vault recovery
// ============================================================

param keyVaultCreateMode = 'default'

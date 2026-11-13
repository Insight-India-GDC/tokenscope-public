
using '../main.bicep'

// TokenScope production parameters.
// Environment-specific values come from the GitHub Environment named "prod".
// Secrets must not be committed to the repository.

param env = 'production'
param location = 'westeurope'
param projectName = 'tokenscopeigdcprod'

// Initial bootstrap image.
// Use an immutable release tag once the image is available.
param imageTag = 'latest'

// PROD deployment identity needs approved resource and RBAC permissions.
param deployRbac = true

// Database and application secrets.
param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')

param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')

param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')

param entraIdClientSecret = readEnvironmentVariable('ENTRA_CLIENT_SECRET')

// Microsoft Entra application for TokenScope human-user sign-in.
// This is separate from the GitHub OIDC deployment identity.
param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'
param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'

param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'
param allowPersonaOverride = false

// Production private networking.
// IMPORTANT: Confirm addresses are approved and do not overlap
// with networks that PROD must connect to.
param enablePrivateNetworking = true

param vnetName = 'vnet-tokenscopeigdc-prod-weu'

param vnetAddressSpace = '10.0.2.0/24'
param containerAppsSubnetPrefix = '10.0.2.0/27'
param privateEndpointsSubnetPrefix = '10.0.2.32/28'
param amplsSubnetPrefix = '10.0.2.48/28'
param buildSubnetPrefix = '10.0.2.64/27'

param registerDnsZoneGroups = true

// Keep Azure Monitor query access unchanged until private DNS
// and Azure Monitor Private Link are validated.
param monitorQueryPrivateOnly = false

// First infrastructure deployment: Front Door remains disabled.
// prod-deploy.yml overrides this from workflow input.
param enableFrontDoor = false
param frontDoorSku = 'Premium'

param frontDoorId = readEnvironmentVariable('FRONT_DOOR_ID', '')

param frontDoorWafManagedRuleAction = 'Log'

// Each of these parameters is declared exactly once.
param appPublicOrigin = readEnvironmentVariable('APP_PUBLIC_ORIGIN', '')
param entraIdRedirectUri = readEnvironmentVariable('ENTRA_REDIRECT_URI', '')
param workerBaseUrl = readEnvironmentVariable('WORKER_BASE_URL', '')

// Change to 'recover' only when intentionally recovering
// a soft-deleted Key Vault with the same name.
param keyVaultCreateMode = 'default'

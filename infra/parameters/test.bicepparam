// TokenScope — PROD parameter template
// Based on the supplied TEST and PROD configurations.
// Do NOT deploy until the PROD network/IPAM allocation, generated resource names,
// and main.bicep env values have been confirmed using validation and What-If.

using '../main.bicep'

// main.bicep previously accepted 'production' (not 'prod').
// IMPORTANT: Confirm current main.bicep allowed values AND name generation
// before running deployment. Changing env can change resource names.
param env = 'production'
param location = 'westeurope'
param projectName = 'tokenscopeigdcprod'

// Bootstrap image. For ongoing image releases, prefer a separately approved
// commit-SHA image deployment using prod-image-deploy.yml.
param imageTag = 'latest'
param deployRbac = true

// Credentials supplied by the GitHub Environment named prod.
param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')
param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')
param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')
param entraIdClientSecret = readEnvironmentVariable('ENTRA_CLIENT_SECRET')

// Human user sign-in application (not GitHub deployment identity).
// Confirm the client/tenant and authorized redirect URI for PROD.
param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'
param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'
param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'
param allowPersonaOverride = false

// Supply production hostnames and callbacks from GitHub Environment secrets/vars.
// These are intentionally declared ONCE (duplicates removed).
param appPublicOrigin = readEnvironmentVariable('APP_PUBLIC_ORIGIN', '')
param entraIdRedirectUri = readEnvironmentVariable('ENTRA_REDIRECT_URI', '')
param workerBaseUrl = readEnvironmentVariable('WORKER_BASE_URL', '')

// Private network settings.
// BLOCKER: CIDRs below are copied from the supplied PROD file and overlap the
// existing TEST CIDRs. Replace ONLY after network/IPAM approval for a NEW VNet.
// If a PROD VNet already exists, do not alter its address space casually.
param enablePrivateNetworking = true
param vnetName = 'vnet-tokenscopeigdc-prod-weu'
param vnetAddressSpace = '10.0.2.0/24' // UNAPPROVED: clashes with TEST
param containerAppsSubnetPrefix = '10.0.2.0/27' // UNAPPROVED
param privateEndpointsSubnetPrefix = '10.0.2.32/28' // UNAPPROVED
param amplsSubnetPrefix = '10.0.2.48/28' // UNAPPROVED
param buildSubnetPrefix = '10.0.2.64/27' // UNAPPROVED
param registerDnsZoneGroups = true
param monitorQueryPrivateOnly = false

// First PROD deployment: Front Door disabled until private app and its
// revision are healthy; handle Front Door in a later approved deployment.
param enableFrontDoor = false
param frontDoorSku = 'Premium'
param frontDoorId = readEnvironmentVariable('FRONT_DOOR_ID', '')
param frontDoorWafManagedRuleAction = 'Log'

param keyVaultCreateMode = 'default'

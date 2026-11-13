using '../main.bicep'

// GitHub Environment = prod; Bicep environment = production.
// No additional GitHub variables or secrets beyond the user-supplied five and nine.
param env = 'production'
param location = 'westeurope'
param projectName = 'tokenscopeigdcprod'
param imageTag = 'latest' // overridden by GitHub workflow with the selected commit SHA
param deployRbac = true

param pgAdminLogin = readEnvironmentVariable('PG_ADMIN_LOGIN')
param pgAdminPassword = readEnvironmentVariable('PG_ADMIN_PASSWORD')
param sessionSecret = readEnvironmentVariable('SESSION_SECRET')
param hmacSessionKey = readEnvironmentVariable('HMAC_SESSION_KEY')
param internalWorkerHmacKey = readEnvironmentVariable('INTERNAL_WORKER_HMAC_KEY')
param oidcSessionSecret = readEnvironmentVariable('OIDC_SESSION_SECRET')
param oidcAuthSessionSecret = readEnvironmentVariable('OIDC_AUTH_SESSION_SECRET')
param oidcTokenKey = readEnvironmentVariable('OIDC_TOKEN_KEY')
param entraIdClientSecret = readEnvironmentVariable('ENTRA_CLIENT_SECRET')

// Human user sign-in, distinct from the GitHub OIDC deployer.
param entraIdClientId = '1d51bb60-1d9b-4d5b-8bbb-6096d583d4af'
param entraIdTenantId = '6c637512-c417-4e78-9d62-b61258e4b619'
param bootstrapAdminEmail = 'manideep.muddagowni@insight.com'
param allowPersonaOverride = false

param enablePrivateNetworking = true
// Let the actual root template generate the correct 'production' naming.
param vnetName = ''
// REVIEW WITH IPAM: these are identical to TEST and must not be used if network connectivity is planned.
param vnetAddressSpace = '10.0.2.0/24'
param containerAppsSubnetPrefix = '10.0.2.0/27'
param privateEndpointsSubnetPrefix = '10.0.2.32/28'
param amplsSubnetPrefix = '10.0.2.48/28'
param buildSubnetPrefix = '10.0.2.64/27'
param registerDnsZoneGroups = true
param monitorQueryPrivateOnly = false

param enableFrontDoor = false // overridden by workflow when provisioning/finalizing AFD
param frontDoorSku = 'Premium'
param frontDoorWafManagedRuleAction = 'Log'
param frontDoorId = '' // X-Azure-FDID instance ID, NOT an ARM resource ID; overridden on finalization
param appPublicOrigin = '' // overridden by workflow on finalization
param entraIdRedirectUri = '' // overridden by workflow on finalization
param workerBaseUrl = '' // empty disables worker-jobs module until finalization
param keyVaultCreateMode = 'default'

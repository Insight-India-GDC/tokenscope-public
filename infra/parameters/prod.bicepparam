using '../main.bicep'

// TokenScope production parameters.
// All environment-specific values come from the GitHub Environment named "prod".
// Secrets remain in GitHub Environment secrets and are never committed.

param env = 'prod'
param location = 'westeurope'
param projectName = 'tokenscopeigdcprod'

// Set the GitHub prod Environment variable IMAGE_TAG to the immutable tag
// produced by prod-image-deploy.yml.
param imageTag = readEnvironmentVariable('IMAGE_TAG')

// The PROD deployment identity needs Contributor plus User Access Administrator
// (or another approved equivalent) at the PROD resource-group scope.
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

// Microsoft Entra application used for TokenScope user sign-in.
// This is separate from AZURE_CLIENT_ID, which belongs to GitHub OIDC deployment.
param entraIdClientId = readEnvironmentVariable('ENTRA_CLIENT_ID')
param entraIdTenantId = readEnvironmentVariable('ENTRA_TENANT_ID')
param bootstrapAdminEmail = readEnvironmentVariable('BOOTSTRAP_ADMIN_EMAIL')

// Production private networking. Use only IPAM-approved, non-overlapping ranges.
param enablePrivateNetworking = true
param vnetName = 'vnet-tokenscopeigdc-prod-weu'
param vnetAddressSpace = readEnvironmentVariable('VNET_ADDRESS_SPACE')
param containerAppsSubnetPrefix = readEnvironmentVariable('ACA_SUBNET_PREFIX')
param privateEndpointsSubnetPrefix = readEnvironmentVariable('PE_SUBNET_PREFIX')
param amplsSubnetPrefix = readEnvironmentVariable('AMPLS_SUBNET_PREFIX')
param buildSubnetPrefix = readEnvironmentVariable('RUNNER_SUBNET_PREFIX')
param registerDnsZoneGroups = true

// Keep Azure Monitor query access unchanged until AMPLS and private DNS are proven.
param monitorQueryPrivateOnly = false

// First deployment: Front Door is disabled by default.
// prod-deploy.yml overrides enableFrontDoor from its workflow input.
// Enable it only after the private Container App revision is healthy.
param enableFrontDoor = false
param frontDoorSku = 'Premium'
param frontDoorId = readEnvironmentVariable('FRONT_DOOR_ID')
param frontDoorWafManagedRuleAction = 'Log'
param appPublicOrigin = readEnvironmentVariable('APP_PUBLIC_ORIGIN')
param entraIdRedirectUri = readEnvironmentVariable('ENTRA_REDIRECT_URI')
param workerBaseUrl = readEnvironmentVariable('WORKER_BASE_URL')

// Change to 'recover' only when intentionally recovering a soft-deleted vault
// with the same globally unique name.
param keyVaultCreateMode = 'default'

using './main.bicep'

// App Service Plan
param appServicePlanName = 'appServicePlan'

// Container Registry
param containerRegistryName = 'sperillaContainerRegistry'
param containerRegistryUsernameSecretName = 'sperilla-cr-username'
param containerRegistryPassword0SecretName = 'sperilla-cr-password0'
param containerRegistryPassword1SecretName = 'sperilla-cr-password1'

// Container App Service
param containerName = 'sperillaAppService'
param dockerRegistryImageName = 'sperillaDockerimg'
param dockerRegistryImageVersion = 'latest'

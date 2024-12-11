// Parameters
param containerRegistryName string
param appServicePlanName string
param location string
param webAppName string
param keyVaultName string

// Key Vault Reference
resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

// Azure Container Registry Module
module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'deployContainerRegistry'
  params: {
    containerRegistryName: containerRegistryName
    location: location
    adminCredentialsKeyVaultResourceId: keyVault.id
    adminCredentialsKeyVaultSecretUserName: 'acr-username'
    adminCredentialsKeyVaultSecretUserPassword1: 'acr-password1'
    adminCredentialsKeyVaultSecretUserPassword2: 'acr-password2'
  }
}

// App Service Plan Module
module appServicePlan 'modules/appService.bicep' = {
  name: 'deployAppServicePlan'
  params: {
    appServicePlanName: appServicePlanName
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
    reserved: true
  }
}

// Web App Module
module webApp 'modules/webApp.bicep' = {
  name: 'deployWebApp'
  dependsOn: [
    containerRegistry
    keyVault
  ]
  params: {
    name: webAppName
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.outputs.loginServer}/${parameters.containerRegistryImageName}:${parameters.containerRegistryImageVersion}'
    }
    appSettingsArray: [
      {
        name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
        value: 'false'
      }
    ]
    dockerRegistryServerUrl: 'https://${containerRegistry.outputs.loginServer}'
    dockerRegistryServerUserName: keyVault.getSecret('acr-username')
    dockerRegistryServerPassword: keyVault.getSecret('acr-password1')
  }
}

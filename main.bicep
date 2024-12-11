// Parameters
param containerRegistryName string = 'sperillaContainerRegistry' // Container Registry Name
param appServicePlanName string = 'sperillaAppServicePlan' // App Service Plan Name
param location string = 'westeurope' // Desired Azure Region
param webAppName string = 'sperillaWebApp' // Web App Name
param keyVaultName string = 'sperillaKeyVault' // Key Vault Name

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
      family: 'F'
      name: 'F1' // Using Free SKU
      size: 'F1'
      tier: 'Free'
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
      linuxFxVersion: 'DOCKER|${containerRegistry.outputs.loginServer}/sperillaimage:latest'
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

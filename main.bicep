@description('Deploys an Azure Container Registry')
param containerRegistryName string
param location string = 'eastus'
param acrAdminUserEnabled bool = true

module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'deployContainerRegistry'
  params: {
    name: containerRegistryName
    location: location
    acrAdminUserEnabled: acrAdminUserEnabled
  }
}

@description('Deploys an Azure App Service Plan for Linux')
param appServicePlanName string
module appServicePlan './modules/appService.bicep' = {
  name: 'deployAppServicePlan'
  params: {
    name: appServicePlanName
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

@description('Deploys an Azure Web App for Linux Containers')
param webAppName string
param containerRegistryImageName string
param containerRegistryImageVersion string
module webApp './modules/webApp.bicep' = {
  name: 'deployWebApp'
  params: {
    name: webAppName
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.serverFarmResourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: 'https://${containerRegistryName}.azurecr.io'
      DOCKER_REGISTRY_SERVER_USERNAME: containerRegistry.outputs.adminUsername
      DOCKER_REGISTRY_SERVER_PASSWORD: containerRegistry.outputs.adminPassword
    }
  }
}

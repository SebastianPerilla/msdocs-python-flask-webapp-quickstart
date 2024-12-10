// Parameters
param containerRegistryName string = 'sperilla_containerRegistry' // Container Registry Name
param appServicePlanName string = 'sperilla_AppServicePlan' // App Service Plan Name
param location string = 'eastus' // Desired Azure Region
param WebAppName string = 'sperilla_WebApp' // Web App Name

// Azure Container Registry Module
module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'deployContainerRegistry'
  params: {
    containerRegistryName: containerRegistryName
    location: location
  }
}

// Azure App Service Plan Module
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

// Pass appSettings as an array
module webApp 'modules/webApp.bicep' = {
  name: 'deployWebApp'
  params: {
    name: WebAppName
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${containerRegistry.outputs.loginServer}/sperilla_dockerimg:latest'
      appCommandLine: ''
    }
    appSettingsArray: [
      {
        name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
        value: 'false'
      }
      {
        name: 'DOCKER_REGISTRY_SERVER_URL'
        value: containerRegistry.outputs.loginServer
      }
      {
        name: 'DOCKER_REGISTRY_SERVER_USERNAME'
        value: containerRegistry.outputs.username
      }
      {
        name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
        value: containerRegistry.outputs.password
      }
    ]
  }
}

@description('Deploys an Azure Container Registry')
module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'deployContainerRegistry'
  params: {
    name: 'myACR'
    location: 'eastus'
    acrAdminUserEnabled: true
  }
}

@description('Deploys an Azure App Service Plan for Linux')
module appServicePlan 'modules/appServicePlan.bicep' = {
  name: 'deployAppServicePlan'
  params: {
    name: 'myAppServicePlan'
    location: 'eastus'
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
module webApp 'modules/webApp.bicep' = {
  name: 'deployWebApp'
  params: {
    name: 'myWebApp'
    location: 'eastus'
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.serverFarmResourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|myacr.azurecr.io/myimage:latest'
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
      DOCKER_REGISTRY_SERVER_URL: 'https://myacr.azurecr.io'
      DOCKER_REGISTRY_SERVER_USERNAME: 'myacrusername'
      DOCKER_REGISTRY_SERVER_PASSWORD: 'myacrpassword'
    }
  }
}

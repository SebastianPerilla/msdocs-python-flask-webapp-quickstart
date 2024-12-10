param name string
param location string = resourceGroup().location
param kind string = 'app'
param appServicePlanName string
param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string
param dockerRegistryServerUrl string
param dockerRegistryServerUsername string
@secure()
param dockerRegistryServerPassword string




var serverFarmResourceId = resourceId('Microsoft.Web/serverfarms', appServicePlanName)

var siteConfig = {
  linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
  appCommandLine: ''
}

var appSettingsKeyValuePairs = {
  WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
  DOCKER_REGISTRY_SERVER_URL: dockerRegistryServerUrl
  DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryServerUsername
  DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryServerPassword
}

resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: siteConfig
  }
}

module app_appsettings 'config--appsettings/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-Site-Config-AppSettings'
  params: {
    appName: app.name
    kind: kind
    appSettingsKeyValuePairs: appSettingsKeyValuePairs
  }
}

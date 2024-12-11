param name string
param location string
param kind string
param serverFarmResourceId string
param siteConfig object
param appSettingsArray array // Accept additional app settings as an array

@secure()
param dockerRegistryServerUrl string
@secure()
param dockerRegistryServerUserName string
@secure()
param dockerRegistryServerPassword string

// Create a variable for app settings that includes the secrets from Key Vault
var dockerAppSettings = [
  {
    name: 'DOCKER_REGISTRY_SERVER_URL'
    value: dockerRegistryServerUrl
  }
  {
    name: 'DOCKER_REGISTRY_SERVER_USERNAME'
    value: dockerRegistryServerUserName
  }
  {
    name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
    value: dockerRegistryServerPassword
  }
]

// Combine siteConfig app settings with the additional app settings
var finalAppSettings = union(appSettingsArray, dockerAppSettings)

// Deploy Azure Web App
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: name
  location: location
  kind: kind
  properties: {
    serverFarmId: serverFarmResourceId
    siteConfig: union(siteConfig, { appSettings: finalAppSettings }) // Combine siteConfig with appSettings
  }
  identity: {
    type: 'SystemAssigned'
  }
}

// Output the Web App ID
output id string = webApp.id

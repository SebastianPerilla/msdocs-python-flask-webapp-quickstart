param containerRegistryName string
param location string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-12-01-preview' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

output loginServer string = containerRegistry.properties.loginServer

// Add username and password outputs
output username string = listKeys(containerRegistry.id, '2021-12-01-preview').username
output password string = listKeys(containerRegistry.id, '2021-12-01-preview').passwords[0].value

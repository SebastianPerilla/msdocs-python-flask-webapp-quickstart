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

// Outputs
output loginServer string = containerRegistry.properties.loginServer

// Retrieve admin username and password for the container registry
output username string = listKeys(containerRegistry.id, '2021-12-01-preview').username
output password string = listKeys(containerRegistry.id, '2021-12-01-preview').passwords[0].value

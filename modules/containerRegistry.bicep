param name string
param location string = resourceGroup().location
param sku string = 'Basic'
param adminUserEnabled bool = true

#disable-next-line secure-secrets-in-params
param usernameSecretName string
#disable-next-line secure-secrets-in-params
param password0SecretName string
#disable-next-line secure-secrets-in-params
param password1SecretName string


resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
  }
}

// Output values for verification (optional, avoid exposing sensitive data)
output containerRegistryName string = containerRegistry.name
output containerRegistryLoginServer string = containerRegistry.properties.loginServer

param name string
param location string
param acrAdminUserEnabled bool = true

module azureContainerRegistry 'modules/azure_container_registry.bicep' = {
  name: 'deployAzureContainerRegistry'
  params: {
    name: name
    location: location
    acrAdminUserEnabled: acrAdminUserEnabled
  }
}

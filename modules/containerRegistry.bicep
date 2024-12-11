param containerRegistryName string
param location string
param adminCredentialsKeyVaultResourceId string
@secure()
param adminCredentialsKeyVaultSecretUserName string
@secure()
param adminCredentialsKeyVaultSecretUserPassword1 string
@secure()
param adminCredentialsKeyVaultSecretUserPassword2 string

// Deploy Azure Container Registry
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

// Reference the Key Vault
resource keyVaultRef 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  resourceId: adminCredentialsKeyVaultResourceId
}

// Store credentials as secrets in the Key Vault
resource usernameSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: adminCredentialsKeyVaultSecretUserName
  properties: {
    value: listCredentials(containerRegistry.id, '2021-12-01-preview').username
  }
  parent: keyVaultRef
}

resource password1Secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: adminCredentialsKeyVaultSecretUserPassword1
  properties: {
    value: listCredentials(containerRegistry.id, '2021-12-01-preview').passwords[0].value
  }
  parent: keyVaultRef
}

resource password2Secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: adminCredentialsKeyVaultSecretUserPassword2
  properties: {
    value: listCredentials(containerRegistry.id, '2021-12-01-preview').passwords[1].value
  }
  parent: keyVaultRef
}

// Outputs
output loginServer string = containerRegistry.properties.loginServer

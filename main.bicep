param userAlias string = 'sperilla'
param location string = resourceGroup().location


// App Service Plan
param appServicePlanName string 

module appServicePlan 'modules/appService.bicep' = {
  name: 'appServicePlan-${userAlias}'
  params: {
    name: appServicePlanName
    location: location
  }
}

// Key Vault
// param keyVaultName string
// param keyVaultRoleAssignments array

// module keyVault 'modules/keyVault.bicep' = {
//   name: 'keyVault-${userAlias}'
//   params: {
//     name: keyVaultName
//     location: location
//     roleAssignments: keyVaultRoleAssignments
//   }
// }

// Container Registry
param containerRegistryName string
param containerRegistryUsernameSecretName string 
param containerRegistryPassword0SecretName string 
param containerRegistryPassword1SecretName string 

module containerRegistry 'modules/containerRegistry.bicep' = {
  name: 'containerRegistry-${userAlias}'
  params: {
    name: containerRegistryName
    location: location
    usernameSecretName: containerRegistryUsernameSecretName
    password0SecretName: containerRegistryPassword0SecretName
    password1SecretName: containerRegistryPassword1SecretName
  }
}

// Container App Service
param containerName string
param dockerRegistryImageName string
param dockerRegistryImageVersion string



module containerAppService 'modules/webApp.bicep' = {
  name: 'containerAppService-${userAlias}'
  params: {
    name: containerName
    location: location
    appServicePlanId: appServicePlan.outputs.id
    registryName: containerRegistryName
    registryImageName: dockerRegistryImageName
    registryImageVersion: dockerRegistryImageVersion
  }
}

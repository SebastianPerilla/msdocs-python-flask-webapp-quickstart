param name string
param location string = resourceGroup().location
param enableVaultForDeployment bool = true

param roleAssignments array = [
  {
    principalId: '7200f83e-ec45-4915-8c52-fb94147cfe5a'
    roleDefinitionIdOrName: 'Key Vault Secrets User'
    principalType: 'ServicePrincipal'
  }
]

param accessPolicies array = [
  {
    tenantId: subscription().tenantId
    objectId: '7200f83e-ec45-4915-8c52-fb94147cfe5a'
    permissions: {
      keys: ['get', 'list']
      secrets: ['get', 'list', 'set']
      certificates: []
    }
  }
]

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: name
  location: location
  properties: {
    enabledForDeployment: enableVaultForDeployment
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: accessPolicies
  }
}

resource keyVault_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(keyVault.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      principalType: roleAssignment.?principalType
    }
    scope: keyVault
  }
]

output resourceId string = keyVault.id
output name string = keyVault.name

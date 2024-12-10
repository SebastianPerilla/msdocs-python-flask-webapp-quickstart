metadata name = 'App Service Plan'
metadata description = 'This module deploys an App Service Plan.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the app service plan.')
@minLength(1)
@maxLength(60)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The SKU of the App Service Plan.')
param sku object = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}

@description('Optional. Kind of server OS.')
param kind string = 'Linux'

@description('Conditional. Defaults to false when creating Windows/app App Service Plan. Required if creating a Linux App Service Plan and must be set to true.')
param reserved bool = true

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  kind: kind
  location: location
  sku: sku
  properties: {
    reserved: reserved
  }
}

@description('The resource group the app service plan was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the app service plan.')
output name string = appServicePlan.name

@description('The resource ID of the app service plan.')
output resourceId string = appServicePlan.id

@description('The location the resource was deployed into.')
output location string = appServicePlan.location

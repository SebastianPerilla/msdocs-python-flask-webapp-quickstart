param appServicePlanName string
param location string
param sku object
param kind string
param reserved bool

// Deploy Azure App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: sku
  kind: kind
  properties: {
    reserved: reserved
  }
}

// Output the App Service Plan ID
output id string = appServicePlan.id

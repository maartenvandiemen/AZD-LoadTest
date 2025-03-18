@description('The tags to associate with the resource')
param tags object

param applicationname string

param applicationInsightsConnectionString string


var appServiceAppName = 'site-${applicationname}-${uniqueString(resourceGroup().id)}'
var appServicePlanName = 'sitePlan-${applicationname}-${uniqueString(resourceGroup().id)}'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: resourceGroup().location
  tags: tags
  sku: {
    name: 'P1V3'
  }
  properties:{
    reserved: false
  }
  kind: 'app'
}

resource appServiceApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appServiceAppName
  tags: union(tags, { 'azd-service-name': 'api' })
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
     acrUseManagedIdentityCreds: false
     netFrameworkVersion: 'v9.0'
     healthCheckPath: '/health'
     appSettings: [
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: applicationInsightsConnectionString
      }
     ]
    }
  }  
  identity: {
    type: 'None'
 }
}

output webAppUrl string = 'https://${appServiceApp.properties.defaultHostName}'

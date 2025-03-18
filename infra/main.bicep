targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

var tags = {
  'azd-env-name': environmentName
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

module loadtest 'modules/loadtest.bicep' ={
  name: 'loadtest'
  scope: rg
  params: {
    tags: tags
  }
}

module appInsights 'modules/applicationInsights.bicep' = {
  name: 'appInsights'
  scope: rg
  params: {
    applicationname: 'todoitems'
    tags: tags
  }
}

module appService 'modules/appService.bicep' = {
  name: 'appService'
  scope: rg
  params: {
    tags: tags
    applicationname: 'todoitems'
    applicationInsightsConnectionString: appInsights.outputs.connectionString
  }
}

output AZURE_LOADTEST_NAME string = loadtest.outputs.loadtestName
output AZURE_RG_NAME string = rg.name
output AZURE_API_HOST string = appService.outputs.webAppUrl

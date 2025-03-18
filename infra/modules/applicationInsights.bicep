param applicationname string

@description('The tags to associate with the resource')
param tags object

var applicationInsightsName = 'insights-${applicationname}-${uniqueString(resourceGroup().id)}'
var workspaceName = 'workspace-${applicationname}-${uniqueString(resourceGroup().id)}'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  tags: tags
  location: resourceGroup().location
  properties: {
    retentionInDays: 30
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  tags: tags
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: workspace.id
  }
}
output connectionString string = appInsights.properties.ConnectionString

@description('The tags to associate with the resource')
param tags object

var uniqueName = uniqueString(resourceGroup().id, subscription().id)

resource loadtest 'Microsoft.LoadTestService/loadTests@2023-12-01-preview' = {
  location: resourceGroup().location
  tags: tags
  name: 'lt-${uniqueName}'
  properties: {
    description: 'Load test for demo purposes'
  }
}

output loadtestName string = loadtest.name

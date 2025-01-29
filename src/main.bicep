param location string = resourceGroup().location
param appName string
param aksClusterName string
param nodeSku string

var storageAccountName = toLower('${appName}${uniqueString(resourceGroup().id)}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}

module aksModule 'modules/aks.bicep' = {
  name: 'aksDeployment'
  params: {
    aksClusterName: aksClusterName
    location: location
    nodeSku: nodeSku
  }
}

output storageAccountId string = storageAccount.id
output aksClusterId string = aksModule.outputs.aksClusterId

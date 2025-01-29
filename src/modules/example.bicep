param exampleName string = 'exampleResource'
param location string = resourceGroup().location

resource exampleResource 'Microsoft.Resources/resourceType@2021-01-01' = {
  name: exampleName
  location: location
  properties: {
    // Add properties specific to the resource here
  }
}

output exampleResourceId string = exampleResource.id
param aksClusterName string
param location string
param nodeSku string

resource sp 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${aksClusterName}-sp'
  location: location
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: aksClusterName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${sp.id}': {}
    }
  }
  properties: {
    agentPoolProfiles: [
      {
        name: 'system'
        count: 1
        vmSize: nodeSku
        osType: 'Linux'
        mode: 'System'
      }
      {
        name: 'user'
        count: 1
        vmSize: nodeSku
        osType: 'Linux'
        mode: 'User'
      }
    ]
    dnsPrefix: '${aksClusterName}-dns'
    servicePrincipalProfile: {
      clientId: sp.properties.clientId
      secret: 'your-client-secret'
    }
  }
}

output aksClusterId string = aksCluster.id

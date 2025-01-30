param location string = resourceGroup().location
param hubVnetName string = 'hubVnet'
param blueSpokeVnetName string = 'bluespokevnet'
param greenSpokeVnetName string = 'greenspokevnet'
param addressSpaceHub string = '10.0.0.0/16'
param addressSpaceBlueSpoke string = '10.1.0.0/16'
param addressSpaceGreenSpoke string = '10.2.0.0/16'
param subnetName string = 'default'
param hubSubnetPrefix string = '10.0.0.0/24'
param blueSpokeSubnetPrefix string = '10.1.0.0/24'
param greenSpokeSubnetPrefix string = '10.2.0.0/24'

resource hubVnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: hubVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpaceHub
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: hubSubnetPrefix
        }
      }
    ]
  }
}

resource blueSpokeVnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: blueSpokeVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpaceBlueSpoke
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: blueSpokeSubnetPrefix
        }
      }
    ]
  }
}

resource greenSpokeVnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: greenSpokeVnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpaceGreenSpoke
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: greenSpokeSubnetPrefix
        }
      }
    ]
  }
}

resource hubToBluePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${hubVnetName}-to-${blueSpokeVnetName}'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: blueSpokeVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource blueToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${blueSpokeVnetName}-to-${hubVnetName}'
  parent: blueSpokeVnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource hubToGreenPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${hubVnetName}-to-${greenSpokeVnetName}'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: greenSpokeVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource greenToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: '${greenSpokeVnetName}-to-${hubVnetName}'
  parent: greenSpokeVnet
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

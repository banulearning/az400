param location string = resourceGroup().location
param storageAccountName string = 'adestorage${uniqueString(resourceGroup().id)}'
param sqlServerName string = 'adesql${uniqueString(resourceGroup().id)}'
param sqlAdminUsername string = 'sqladminuser'
@secure()
param sqlAdminPassword string
param dataFactoryName string = 'adf-${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServer.name}/sampledb'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    readScale: 'Disabled'
  }
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  properties: {}
}

targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //
@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(80)
param resourceGroupName string = 'ms.sql.managedinstances-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'sqlmimin'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

// =========== //
// Deployments //
// =========== //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module resourceGroupResources 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    virtualNetworkName: 'dep-<<namePrefix>>-vnet-${serviceShort}'
    networkSecurityGroupName: 'dep-<<namePrefix>>-nsg-${serviceShort}'
    routeTableName: 'dep-<<namePrefix>>-rt-${serviceShort}'
    location: location
  }
}

// ============== //
// Test Execution //
// ============== //

// module testDeployment '../../deploy.bicep' = {
//   scope: resourceGroup
//   name: '${uniqueString(deployment().name)}-test-${serviceShort}'
//   params: {
//     name: '<<namePrefix>>-${serviceShort}'
//     administratorLogin: 'adminUserName'
//     administratorLoginPassword: password
//     subnetId: resourceGroupResources.outputs.subnetResourceId
//   }
// }

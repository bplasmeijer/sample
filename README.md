# My Bicep Project

This project contains Bicep templates for deploying resources in Azure.

## Project Structure

- **src/main.bicep**: The main Bicep template that defines the resources to be deployed.
- **src/modules/example.bicep**: A Bicep module that encapsulates specific resources for reuse.
- **azuredeploy.json**: An Azure Resource Manager (ARM) template for deploying the Bicep templates.

## Prerequisites

- Azure subscription
- Azure CLI installed
- Bicep CLI installed

## Deployment Instructions

1. Ensure you are logged into your Azure account:
   ```
   az login
   ```

2. Deploy the Bicep template using the Azure CLI:
   ```
   az deployment group create --resource-group <your-resource-group> --template-file src/main.bicep
   ```

Replace `<your-resource-group>` with the name of your Azure resource group.

## Additional Information

For more details on Bicep, visit the [Bicep documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/).
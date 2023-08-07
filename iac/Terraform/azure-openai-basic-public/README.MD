# Introduction
This Terraform code is defining a set of modules that are used to create an Azure OpenAI instance with ChatGPT deployment in Azure.

# Build and Test
Usage: [Explained](https://learn.microsoft.com/en-us/azure/developer/terraform/
1. terraform init
2. terraform plan -var-file="./environments/production.tfvars" -out main.tfplan
3. terraform apply main.tfplan

# Destroy
1. terraform plan -destroy -var-file="./environments/production.tfvars" -out main.tfplan
2. terraform apply main.tfplan

# Modules Explained
Here is an overview of what each module does.

## Main.tf (root)
This Terraform code sets up a deployment for an "openai" module in Azure. Here's what it does:

It creates a random string resource named "prefix" with a length of 6 characters and no special, uppercase, or numeric characters.
It creates an Azure resource group named "rg-${var.name_prefix}-${var.openai_name}-${random_string.prefix.result}". The location and tags are determined by the corresponding variables.

It defines a module named "openai" with the source located at "./modules/openai".
Within the module, it configures various properties:
- "name" is set to a lowercase value based on conditions. If "var.name_prefix" is null, it uses "${random_string.prefix.result}${var.openai_name}-${random_string.prefix.result}". Otherwise, it uses "${var.name_prefix}-${var.openai_name}-${random_string.prefix.result}".
- "location" is set based on the provided variable value.
- "resource_group_name" is set to the name of the Azure resource group created earlier.
- "sku_name" is set based on the value of the variable "var.openai_sku_name".
- "tags" are set based on the corresponding variable.
- "deployments" are specified based on the value of the variable "var.openai_deployments".
- "custom_subdomain_name" is determined based on conditions. If "var.openai_custom_subdomain_name" is empty or null, it uses a generated value. Otherwise, it uses the provided value.
- "public_network_access_enabled" is set based on the value of the variable "var.openai_public_network_access_enabled".

Overall, this code provisions Azure resources, including a resource group, and deploys an "openai" module with configurable settings.

## variables.tf (root)
This Terraform code defines a set of variables that can be used to configure the deployment of Azure resources. Here's a breakdown of each variable:

-name_prefix
An optional prefix for the name of resource groups and resources. It is of type string, has a default value of "Example," and can be set to null.
- environment
A string variable representing the environment (e.g., development, production).
company
A string variable representing the company or organization name.
- location
Specifies the location (Azure region) for the resource group and all resources. It has a default value of "northeurope" but can be modified.
- resource_group_name
Specifies the name of the resource group. It has a default value of "rg" but can be modified.
- openai_name
The required name of the Azure OpenAI Service.
- openai_sku_name
An optional SKU (stock-keeping unit) name for the Azure OpenAI Service. It has a default value of "S0" but can be modified.
- openai_custom_subdomain_name
An optional custom subdomain name for the Azure OpenAI Service. It can be set to null or an empty string.
- openai_public_network_access_enabled
An optional boolean value indicating whether public network access is allowed for the Azure OpenAI Service. It has a default value of true but can be modified.
- openai_deployments
An optional list of deployments for the Azure OpenAI Service. Each deployment includes a name, model (with name and version), and RAI policy name.
- tags
Optional tags to assign to all resources created by the Terraform code. It has a default value that includes a tag "CreatedWith" set to "Terraform."
- sku_name
An optional SKU name for an Azure web app. It has a default value of "B1" but can be modified.

## openai (module)
This Terraform code defines Azure resources for an OpenAI cognitive service deployment. Here's what it does:

It creates an Azure Cognitive Services account (azurerm_cognitive_account) with the specified configuration, including name, location, resource group, kind ("OpenAI"), custom subdomain name, SKU name, network access settings, tags, and system-assigned identity.

It specifies a lifecycle block to ignore changes in the tags attribute of the cognitive account.

It creates an Azure Cognitive Services deployment (azurerm_cognitive_deployment) for each deployment specified in the var.deployments list. Each deployment has a unique name and is associated with the previously created cognitive account.

Each deployment includes a model with the format "OpenAI" and specific name and version values taken from the corresponding entry in 
var.deployments

Each deployment also includes a scale block specifying the type as "Standard".

In summary, this code provisions an Azure Cognitive Services account and sets up one or more deployments within that account, each tied to a specific model.

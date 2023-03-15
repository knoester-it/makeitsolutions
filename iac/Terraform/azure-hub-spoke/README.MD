# Introduction
This Terraform code is defining a set of modules that are used to create a network Hub-Spoke  topology in Azure.

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
1. random_integer: This module generates a random integer between 100 and 299.

2. random_id: This module generates a random ID with a byte length of 4.

3. network_hub: This module creates a hub virtual network in Azure. It uses the rg_name_hub parameter to specify the name of the resource group for the hub, and name_hub to specify the name of the hub virtual network. The name_spoke parameter is set to the name of the spoke virtual network created by the network_spoke module. The location parameter is set to the Azure region where the resources will be deployed. network_address_space_hub is used to define the IP address space for the hub network. Finally, the module depends on the network_spoke module.

4. network_spoke: This module creates a spoke virtual network in Azure. It uses the random_integer parameter to generate a random number to be used in the resource names. The name_spoke parameter is set to the name of the spoke virtual network. The location parameter is set to the Azure region where the resources will be deployed. network_address_space_spoke is used to define the IP address space for the spoke network.

5. keyvault: This module creates an Azure Key Vault. The random_integer parameter is used to generate a random number to be used in the resource names. name_company_department is used to define the name of the Key Vault. location is set to the Azure region where the resources will be deployed.

6. azfirewall: This module creates an Azure Firewall. It uses the rg_name_hub parameter to specify the name of the resource group for the hub, and vnet_name_hub to specify the name of the hub virtual network. The name_spoke parameter is set to the name of the spoke virtual network. The location parameter is set to the Azure region where the resources will be deployed. network_address_space_spoke is used to define the IP address space for the spoke network, and network_address_space_firewall is used to define the IP address space for the Azure Firewall. Finally, the module depends on the network_hub module.

In summary, this Terraform code generates random input, creates several modules that define network resources in Azure, and sets dependencies between the modules. The modules include creating a hub network, spoke network, Azure Key Vault, and Azure Firewall.

### Defining Dependancies
Finally, the code defines dependencies between the different modules using the depends_on attribute. module.network_hub depends on module.network_spoke, and module.azfirewall 

## variables.tf (root)
This Terraform code defines a set of input variables that can be used throughout your Terraform code to define different properties of your infrastructure.

Here's a brief explanation of each variable:

- environment: This variable is used to specify the environment (e.g. "prod", "stage", "dev") in which the infrastructure will be deployed.
- location: This variable is used to specify the location (e.g. "eastus", "westus2", "centralus") in which the infrastructure will be deployed.
- company: This variable is used to specify the company or organization that owns the infrastructure.
- name_hub: This variable is used to specify the name of the virtual network that will be created.
network_address_space_hub: This variable is used to specify the address space for the virtual network.
- name_spoke: This variable is used to specify a list of spoke virtual network names.
- network_address_space_spoke: This variable is used to specify a list of address spaces for the spoke virtual networks.
- network_address_space_firewall: This variable is used to specify a list of address spaces for the firewall subnet.
- spoke_endpoint_subnet_name: This variable is used to specify the name of the spoke endpoint subnet.
- spoke_privatelinkendpoints_subnet_name: This variable is used to specify the name of the spoke private link endpoints subnet.

By defining these variables, you can easily reuse them throughout your Terraform code to keep your infrastructure code flexible and maintainable. You can set the values for these variables in your main Terraform configuration file, or in separate configuration files for different environments.

## azfirewall (module)
This Terraform code provisions Azure Firewall resources including the firewall itself, its subnet, and public IP address. It also defines firewall rules and creates route tables for each spoke to route traffic to the firewall.

The specific resources created by this code are:

- azurerm_subnet resource that creates a subnet for the Azure Firewall. This resource specifies the name, resource group, and address prefix for the subnet.

- azurerm_public_ip resource that creates a public IP address for the Azure Firewall. This resource specifies the name, resource group, location, allocation method, and SKU for the public IP.

- azurerm_firewall resource that creates an Azure Firewall. This resource specifies the name, resource group, location, SKU name, SKU tier, and IP configuration, which includes the subnet and public IP address created in the previous steps.

- azurerm_firewall_application_rule_collection resource that creates an Azure Firewall application rule collection. This resource specifies the name, Azure Firewall name, resource group, priority, action, source addresses, target FQDNs, and protocol, which allows traffic from the source addresses to the target FQDNs on the specified port and protocol.

- azurerm_firewall_network_rule_collection resource that creates an Azure Firewall network rule collection. This resource specifies the name, Azure Firewall name, resource group, priority, action, source addresses, destination addresses, destination ports, and protocols, which allows traffic from the source addresses to the destination addresses and ports on the specified protocols.

- azurerm_route_table resource that creates a route table for each spoke. This resource specifies the name, location, resource group, and route, which routes traffic from the spoke to the Azure Firewall. The next hop type is "VirtualAppliance", which means that traffic is routed to the private IP address of the Azure Firewall's IP configuration.

The variables used in this code are defined in another file and include the environment, location, company, virtual network and subnet names, address spaces for the virtual network and subnets, and names of the spokes.

## keyvault (module)
This Terraform code is used to create an Azure Key Vault instance with a standard SKU, enabled for disk encryption, and with access policy permissions granted to the user that is executing the Terraform code. Here's a brief explanation of each section:

- data "azurerm_client_config" "current" {}: This section retrieves the client configuration data, such as tenant ID and object ID, for the user executing the Terraform code.
- resource "azurerm_resource_group" "keyvault" {}: This section creates an Azure resource group to contain the Key Vault instance.
- resource "random_id" "azurerm_name_suffix" {}: This section generates a random ID to append to the Key Vault name to ensure uniqueness.
- resource "azurerm_key_vault" "management" {}: This section creates the Key Vault instance with the specified configuration settings. It also sets the access policy to allow the executing user to have Get permissions for keys, secrets, and storage.
Note that the lower function is used to convert the names to lowercase, and that some variables are used to define some of the properties of the resources, such as var.location, var.environment, var.company, var.name_company_department, and var.random_integer.

## network_hub (module)
This Terraform code sets up a hub-and-spoke network topology in Azure. The hub is represented by an Azure Resource Group, a virtual network (VNet), and a virtual network peering that connects the hub to each of the spokes.

The first resource creates an Azure Resource Group that will hold the shared resources of the hub network.

The second resource creates an Azure Virtual Network that represents the hub network. It has a name, an address space, and is located in the previously created Resource Group.

The third resource creates a virtual network peering from the hub to each of the spokes. It creates a peering for each spoke specified in the var.name_spoke list. The peering is created in the hub resource group and uses the virtual network created in the second resource. It also specifies the remote virtual network ID for each spoke in the var.remote_virtual_network_id list.

The fourth resource creates a virtual network peering from each spoke to the hub network. It creates a peering for each spoke specified in the var.name_spoke list. The peering is created in the spoke's own resource group and uses the spoke's virtual network, and it peering to the hub network that was created in the second resource.

## network_spoke (module)
In this section, resources for Spoke VNET are defined, including subnets for Endpoint and Private Link.

The resources defined here include:

- azurerm_virtual_network: This resource creates a virtual network for the spoke. The address_space parameter is used to define the IP address space for the virtual network. The location and resource_group_name parameters are used to specify the location and resource group for the virtual network.
- azurerm_subnet: This resource creates a subnet for the spoke. The name parameter is used to specify the name of the subnet. The virtual_network_name parameter is used to associate the subnet with the virtual network created earlier. The address_prefixes parameter is used to specify the IP address space for the subnet. The resource_group_name parameter is used to specify the resource group for the subnet.
- azurerm_network_security_group: This resource creates a network security group for the spoke. The name parameter is used to specify the name of the network security group. The location and resource_group_name parameters are used to specify the location and resource group for the network security group. The security_rule block is used to define the rules for the network security group.
- azurerm_subnet_network_security_group_association: This resource associates the subnet with the network security group. The subnet_id parameter is used to specify the ID of the subnet. The network_security_group_id parameter is used to specify the ID of the network security group.
The rules defined for the network security group are:

Inbound rule to allow all traffic on port 443
Inbound rule to allow all traffic on port 3389
Inbound rule to allow all traffic on port 22
There are also outbound deny rules for all traffic to ensure that only traffic on the allowed ports can go through.

Note that the azurerm_virtual_network and azurerm_subnet resources are created with a count parameter. This allows multiple spoke virtual networks and subnets to be created if multiple spoke names are specified in the var.name_spoke variable. The same applies to the azurerm_network_security_group and azurerm_subnet_network_security_group_association resources.
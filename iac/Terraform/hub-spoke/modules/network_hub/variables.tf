variable "rg_name_hub" {
}

variable "company" {
  type        = string
  description = "Company"
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "Production"
}
variable "location" {
  type        = string
  description = "Location of Resources"
  default     = "westeurope"
}

variable "name_hub" {
    type        = string
    description = "List of all the hubs"
}

variable name_spoke {
    type        = list(string)
    description = "List of all the spokes"
}

variable "network_address_space_hub" {
    type        = string
    description = "List of all the address spaces"
}

variable "remote_virtual_network_id" {
    #type        = string
    description = "Remote Virtual Network id from spoke(s)"
}

variable "resource_group_name_spoke" {
    #type        = string
    description = "Remote Virtual Network id from spoke(s)"
}

variable "vnet_name_spoke" {
    #type        = string
    description = "Remote Virtual Network id from spoke(s)"
}

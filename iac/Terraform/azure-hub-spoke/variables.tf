variable "environment" {
  type        = string
  description = "Environment"
}

variable "location" {
  type        = string
  description = "Location of Resources"
}

variable "company" {
  type        = string
  description = "Company"
}

variable "name_hub" {
  type        = string
  description = "Virtual Network Name"
}

variable "network_address_space_hub" {
  type        = string
  description = "Virtual Network Address Space"
}

variable name_spoke {
    type        = list(string)
    description = "List of all the spokes"
}

variable network_address_space_spoke {
    type        = list(string)
    description = "List of all the address spaces"
}

variable network_address_space_firewall {
    type        = list(string)
    description = "Firewall subnet address space"
}

variable spoke_endpoint_subnet_name {
    type        = string
    description = "Spoke endpoint subnet name"
}

variable spoke_privatelinkendpoints_subnet_name {
    type        = string
    description = "Spoke privatelink subnet name"
}  
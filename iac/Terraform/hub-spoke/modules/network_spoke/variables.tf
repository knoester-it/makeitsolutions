variable "random_integer" {
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

variable name_spoke {
    type        = list(string)
    description = "List of all the spokes"
}

variable network_address_space_spoke {
    type        = list(string)
    description = "List of all the address spaces"
}

variable spoke_endpoint_subnet_name {
    type        = string
    description = "Spoke endpoint subnet name"
}

variable spoke_privatelinkendpoints_subnet_name {
    type        = string
    description = "Spoke privatelink subnet name"
}
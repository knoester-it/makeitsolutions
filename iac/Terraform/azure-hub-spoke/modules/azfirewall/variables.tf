variable "rg_name_hub" {
  type        = string
}

variable "vnet_name_hub" {
  type        = string
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "Production"
}

variable "company" {
  type        = string
  description = "Company"
  default     = "Production"
}

variable "location" {
  type        = string
  description = "Location of Resources"
  default     = "westeurope"
}

variable "network_address_space_spoke" {
  type        = list
}

variable "network_address_space_firewall" {
  type        = list(string)
}
variable name_spoke {
    type        = list(string)
    description = "List of all the spokes"
}
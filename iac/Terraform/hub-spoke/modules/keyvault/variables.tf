variable "name_company_department" {
  description = "Resource Group"
}

variable "random_integer" {
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
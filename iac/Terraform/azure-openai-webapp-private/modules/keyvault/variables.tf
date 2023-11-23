variable "name_prefix" {
  description = "(Optional) A prefix for the name of all the resource groups and resources."
  type        = string
  default     = "Example"
  nullable    = true
}

variable "name_company_department" {
  description = "Name of the Company Department"
}

variable "random_string" {
}

variable "environment" {
  type        = string
  description = "Environment"
  default     = "Production"
}

variable "company" {
  type        = string
  description = "Company"
  default     = "makeit"
}


variable "location" {
  type        = string
  description = "Location of Resources"
  default     = "westeurope"
}
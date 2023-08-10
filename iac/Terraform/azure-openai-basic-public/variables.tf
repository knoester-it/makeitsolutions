variable "name_prefix" {
  description = "(Optional) A prefix for the name of all the resource groups and resources."
  type        = string
  default     = "Example"
  nullable    = true
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "company" {
  type        = string
  description = "Company"
}

variable "location" {
  description = "Specifies the location for the resource group and all the resources"
  default     = "northeurope"
  type        = string
}

variable "resource_group_name" {
  description = "Specifies the resource group name"
  default     = "rg"
  type        = string
}

variable "openai_name" {
  description = "(Required) Specifies the name of the Azure OpenAI Service"
  type = string
  default = "OpenAi"
}

variable "openai_sku_name" {
  description = "(Optional) Specifies the sku name for the Azure OpenAI Service"
  type = string
  default = "S0"
}

variable "openai_custom_subdomain_name" {
  description = "(Optional) Specifies the custom subdomain name of the Azure OpenAI Service"
  type = string
  nullable = true
  default = ""
}

variable "openai_public_network_access_enabled" {
  description = "(Optional) Specifies whether public network access is allowed for the Azure OpenAI Service"
  type = bool
  default = true
}

variable "openai_deployments" {
  description = "(Optional) Specifies the deployments of the Azure OpenAI Service"
  type = list(object({
    name = string
    model = object({
      name = string
      version = string
    })
    rai_policy_name = string  
  }))
  default = [
    {
      name = "gpt-35-turbo-16k"
      model = {
        name = "gpt-35-turbo-16k"
        version = "0613"
      }
      rai_policy_name = ""
    }
  ] 
}

variable "tags" {
  description = "(Optional) Specifies tags for all the resources"
  default     = {
    CreatedWith = "Terraform"

  }
}

variable "sku_name" {
  description = "(Optional) Specifies the sku name for the Azure webapp"
  type = string
  default = "B1"
}

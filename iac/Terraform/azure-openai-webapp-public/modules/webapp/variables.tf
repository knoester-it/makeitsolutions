variable "resource_group_name" {
  description = "(Required) Specifies the resource group name"
  type = string
}

variable "key_vault_resource_group" {
  description = "(Required) Specifies the resource group name for key vault"
  type = string
}

variable "key_vault_name" {
  description = "(Required) Specifies the key vault name"
  type = string
}

variable "location" {
  description = "(Required) Specifies the location of the Azure webapp"
  type = string
}

variable "name" {
  description = "(Required) Specifies the name of the Azure webapp"
  type = string
}

variable "sku_name" {
  description = "(Optional) Specifies the sku name for the Azure webapp"
  type = string
  default = "B1"
}

variable "tags" {
  description = "(Optional) Specifies the tags of the Azure webapp"
  type        = map(any)
  default     = {}
}

variable "openai_name" {
  description = "(Required) Specifies the name of the Azure OpenAI resource"
  type = string
}

variable "openai_primary_access_key" {
  description = "(Required) Specifies the primary access key of the Azure OpenAI resource"
  type = string
}

/* variable "app_application_id" {
  description = "(Required) Specifies the application id of the Azure AD application"
  type = string
} */

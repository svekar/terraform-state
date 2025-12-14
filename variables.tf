variable "resource_group_name" {
  description = "Name of the resource group to create."
  type        = string
  default     = "tfstate"
}

variable "storage_account_name" {
  description = "Name of the storage account (must be globally unique)."
  type        = string
  default     = "svejks6tfstate"
}

variable "container_name" {
  description = "Name of the storage container for Terraform state."
  type        = string
  default     = "tfstate"
}

variable "tags" {
  description = "Tags to apply to created resources."
  type        = map(string)
  default     = {}
}
variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "swedencentral"
}

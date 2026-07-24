variable "name" {
  type        = string
  description = "Storage account name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "account_tier" {
  type        = string
  description = "Storage tier (Standard or Premium)"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "Replication type (LRS, GRS, ZRS, RAGRS)"
  default     = "LRS"
}

variable "container_name" {
  type        = string
  description = "Name of initial private storage container"
  default     = "tfstate-system"
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default     = {}
}

variable "name" {
  description = "Name of the Container Registry"
  type        = string

  validation {
    condition     = length(var.name) >= 5 && length(var.name) <= 50 && can(regex("^[a-z0-9]+$", var.name))
    error_message = "Container Registry name must be 5-50 characters, lowercase alphanumeric only."
  }
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium."
  }
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = false
}

variable "georeplications" {
  description = "Georeplication locations (Premium SKU only)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}




output "id" {
  value       = azurerm_storage_account.this.id
  description = "Storage Account ID"
}

output "name" {
  value       = azurerm_storage_account.this.name
  description = "Storage Account Name"
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.this.primary_blob_endpoint
  description = "Primary Blob Endpoint"
}

output "primary_access_key" {
  value       = azurerm_storage_account.this.primary_access_key
  description = "Primary Access Key"
  sensitive   = true
}

output "container_name" {
  value       = length(azurerm_storage_container.this) > 0 ? azurerm_storage_container.this[0].name : var.container_name
  description = "Storage Container Name"
}

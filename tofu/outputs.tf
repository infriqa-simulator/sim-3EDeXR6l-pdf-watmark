# Outputs for Terraform configuration
# Environment: dev

output "acr_login_server" {
  description = "ACR Login Server"
  value       = module.container_registry.login_server
}

output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.log_analytics.id
}

output "pdf-watermarker-frontend_url" {
  description = "URL of pdf-watermarker-frontend"
  value       = module.pdf_watermarker_frontend_app.default_host_name
}

output "pdf-watermarker-service_id" {
  description = "Resource ID of pdf-watermarker-service"
  value       = module.pdf_watermarker_service_app.id
}

output "pdf-watermarker-service_url" {
  description = "URL of pdf-watermarker-service"
  value       = module.pdf_watermarker_service_app.latest_revision_fqdn
}

output "resource_group_id" {
  description = "Resource group ID"
  value       = module.main_rg.id
}

output "resource_group_name" {
  description = "Resource group name"
  value       = module.main_rg.name
}

output "shared_resource_group_name" {
  description = "Shared resource group name"
  value       = module.shared_rg.name
}

output "tfstate_container_name" {
  description = "TF State Container Name"
  value       = module.tfstate_storage.container_name
}

output "tfstate_storage_account_name" {
  description = "TF State Storage Account Name"
  value       = module.tfstate_storage.name
}

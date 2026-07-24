# Terraform configuration generated from Resource Plan
# Environment: dev
# Generated from deterministic resource plan (Phase 2)

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
  # Remote state for simulator detect/heal (uploaded post-apply into project tfstate SA)
  backend "azurerm" {
    resource_group_name  = "sim-3EDeXR6l-pdf-watmark-dev-rg"
    storage_account_name = "sim3edexr6lpdfwatmarkdev"
    container_name       = "tfstate-system"
    key                  = "apps/sim-3EDeXR6l-pdf-watmark-dev/dev.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

# Merge var.environment into tags so every resource carries the environment label.
# This ensures var.environment is consumed and not dead code.
locals {
  common_tags = merge(var.tags, { environment = var.environment })
}

# ========================================
# Phase: 1 Foundation
# ========================================

# Module: main_rg (azurerm_resource_group)
module "main_rg" {
  source = "./modules/azure-resource-group"

  location = var.location
  name     = "sim-3EDeXR6l-pdf-watmark-dev-rg"
  tags     = local.common_tags
}

# Module: shared_rg (azurerm_resource_group)
module "shared_rg" {
  source = "./modules/azure-resource-group"

  location = var.location
  name     = "platform-shared-rg"
  tags     = local.common_tags
}

# Module: log_analytics (azurerm_log_analytics_workspace)
module "log_analytics" {
  source = "./modules/azure-log-analytics-workspace"

  location            = var.location
  name                = "sim-3edexr6l-pdf-watmark-dev-infrastructure"
  resource_group_name = module.shared_rg.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
  tags                = local.common_tags
}

# ========================================
# Phase: 2 Shared Infrastructure
# ========================================

# Resource: app_pdf_watermarker_service (azurerm_container_app_environment)
resource "azurerm_container_app_environment" "app_pdf_watermarker_frontend" {
  name                       = "myorg-sim-3edexr6l-pdf-watmark-dev-shared-dev-southcentralus"
  location                   = var.location
  resource_group_name        = module.main_rg.name
  log_analytics_workspace_id = module.log_analytics.id
  tags                       = local.common_tags
}

# Module: container_registry (azurerm_container_registry)
module "container_registry" {
  source = "./modules/azure-container-registry"

  admin_enabled       = true
  location            = var.location
  name                = "sim3edexr6lpdfwatmarkdevinfrastructure1"
  resource_group_name = module.shared_rg.name
  sku                 = "Basic"
  tags                = local.common_tags
}

# Module: tfstate_storage (azurerm_storage_account)
module "tfstate_storage" {
  source = "./modules/azure-storage-account"

  account_replication_type = "LRS"
  account_tier             = "Standard"
  container_name           = "tfstate-system"
  location                 = var.location
  name                     = "sim3edexr6lpdfwatmarkdev"
  resource_group_name      = module.main_rg.name
  tags                     = local.common_tags
}

# ========================================
# Phase: 4 Compute
# ========================================

# Module: pdf_watermarker_frontend_app (azurerm_static_site)
module "pdf_watermarker_frontend_app" {
  source = "./modules/azure-static-site"

  app_settings = {
    BACKEND_API_URL = "https://${module.pdf_watermarker_service_app.latest_revision_fqdn}"
  }
  location            = var.location
  name                = "sim-3edexr6l-pdf-watmark-dev-pdf-watermarker-frontend"
  resource_group_name = module.main_rg.name
  sku_size            = "Free"
  sku_tier            = "Free"
  tags                = local.common_tags
}

# Module: pdf_watermarker_service_app (azurerm_container_app)
module "pdf_watermarker_service_app" {
  source = "./modules/azure-container-app"

  container_app_environment_id = azurerm_container_app_environment.app_pdf_watermarker_frontend.id
  containers                   = [{ "name" : "pdf-watermarker-service", "image" : "${var.pdf_watermarker_service_image}", "cpu" : 0.25, "memory" : "0.5Gi", "env" : [] }]
  ingress = {
    external_enabled = true
    target_port      = 8080
    transport        = "http"
  }
  location            = var.location
  name                = "sim-3edexr6l-pdf-watmark-dev-pdf"
  resource_group_name = module.main_rg.name
  revision_mode       = "Single"
  tags                = local.common_tags
}

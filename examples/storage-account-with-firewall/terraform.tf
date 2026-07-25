terraform {
  required_version = "~> 1.8"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "2.11.0"
    }
  }
}

provider "azapi" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

data "azapi_client_config" "current" {}

module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.3"

  suffix = ["finops", "focus"]
}

locals {
  tags = {
    createdBy         = "Terraform"
    module_repository = "github.com/alexandre-pares/terraform-azure-finops-focus-billing-export"
    module_version    = "v2.0.0"
    environment       = "mgmt"
    application       = "finops-focus"
  }
}

module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.4.0"

  name     = module.naming.resource_group.name_unique
  location = "switzerlandnorth"

  tags = local.tags

  enable_telemetry = false
}

module "focus_billing_storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.7.2"

  name = module.naming.storage_account.name_unique

  location  = module.resource_group.location
  parent_id = module.resource_group.resource_id

  account_sku_name = "Standard_LRS"

  cross_tenant_replication_enabled = true
  is_hns_enabled                   = false

  public_network_access_enabled = true

  default_to_oauth_authentication = true
  shared_access_key_enabled       = true # Required for billing export

  network_rules = {
    ip_rules = [var.ipv4_address]
  }


  containers = {
    focus = {
      name = "focus"
      role_assignments = {
        rbac_storage_blob_data_contributor = {
          role_definition_id_or_name = "Storage Blob Data Owner"
          principal_id               = data.azapi_client_config.current.object_id
        }
      }
    }
  }

  tags = local.tags

  enable_telemetry = false
}

module "finops_focus_billing_export" {
  source = "../.."

  name           = substr("finops-focus-billing-export-4-sub-${var.subscription_id}", 0, 64)
  description    = "FinOps FOCUS billing export for subscription ${var.subscription_id}"
  export_version = "1.2-preview"
  scope_id       = "/subscriptions/${var.subscription_id}"

  storage_account_id = module.focus_billing_storage_account.resource_id
  container_name     = "focus"

  directory = "v1.2-preview/sub_${var.subscription_id}"

  creation_date = "2026-06-07"
  start_date    = "2026-04-01"
  end_date      = "2050-01-01"

  enable_backfill = true
}

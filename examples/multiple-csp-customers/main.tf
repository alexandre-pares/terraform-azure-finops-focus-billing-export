module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.3"

  suffix = ["finops", "focus"]
}

locals {
  tags = {
    createdBy         = "Terraform"
    module_repository = "github.com/alexandre-pares/terraform-azure-finops-focus-billing-export"
    module_version    = "v2.1.0"
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
  version = "0.7.3"

  name = module.naming.storage_account.name_unique

  location  = module.resource_group.location
  parent_id = module.resource_group.resource_id

  account_sku_name = "Standard_LRS"

  cross_tenant_replication_enabled = false
  is_hns_enabled                   = false

  public_network_access_enabled = true

  default_to_oauth_authentication = true
  shared_access_key_enabled       = true # Required for billing export

  network_rules = null # Allow access from all networks (public)

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

  for_each = var.customers

  name           = substr("finops-focus-billing-export-for-csp-cutomer-${each.value.id}", 0, 64)
  description    = "FinOps FOCUS billing export for CSP Customer ${each.value.id}"
  export_version = "1.2-preview"
  scope_id       = "/providers/Microsoft.Billing/billingAccounts/${var.mpa_id}/customers/${each.value.id}"

  storage_account_id = module.focus_billing_storage_account.resource_id
  container_name     = "focus"

  directory = "v1.2-preview/csp_customer_${each.value.id}"

  creation_date = "2026-06-07"
  start_date    = "2026-03-01"
  end_date      = "2050-01-01"

  enable_backfill = true
}

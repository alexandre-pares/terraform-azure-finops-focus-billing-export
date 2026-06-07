resource "azapi_resource" "focus_export" {
  type = "Microsoft.CostManagement/exports@2023-07-01-preview"

  # Scope of the billing export
  parent_id = var.scope_id

  # Name of the export
  name     = var.name
  location = "global"

  # Identity
  identity {
    type = "SystemAssigned"
  }

  body = {
    properties = {
      definition = {
        # Export type (focus)
        type = "FocusCost"
        # Export period (Month to date)
        timeframe = "MonthToDate"
        dataSet = {
          configuration = {
            # Version of the export
            # 1.0 for FOCUS v1.0
            dataVersion = var.export_version
          }
          granularity = "Daily"
        }
      }
      deliveryInfo = {
        "destination" : {
          # Id of the Storage Account
          resourceId = var.storage_account_id

          # Name of the storage account container
          container = var.container_name

          # Directory of the export
          rootFolderPath = var.directory

          type = "AzureBlob"
        }
      }
      schedule = {
        recurrence : "Daily"
        recurrencePeriod = {
          from = "${var.start_date}T00:00:00Z"
          to   = "${var.end_date}T00:00:00Z"
        }
        status = "Active"
      }
      format                = "Parquet"
      partitionData         = true
      dataOverwriteBehavior = "OverwritePreviousReport"
      compressionMode       = "snappy"
      exportDescription     = var.description
    }
  }
}

/* -------------------- Get a list of months to backfill -------------------- */
module "months_to_backfill" {
  source = "./modules/months_to_backfill"

  # Generate list of month to backfill,
  # if `var.enable_backfill` is `false`, then only the current month will be backfilled at export creation
  start_date    = var.enable_backfill ? var.start_date : "${substr(var.creation_date, 0, 7)}-01"
  creation_date = var.creation_date
  end_date      = var.end_date
}

/* ------------------------------ Backfill job ------------------------------ */
resource "azapi_resource_action" "backfill_job" {
  for_each = { for i, month in module.months_to_backfill.months_to_backfill : i => month }

  type                   = "Microsoft.CostManagement/exports@2023-07-01-preview"
  resource_id            = azapi_resource.focus_export.id
  action                 = "run"
  response_export_values = ["*"]
  body = {
    timePeriod = {
      from = each.value.start_date
      to   = each.value.end_date
    }
  }
  locks = ["${azapi_resource.focus_export.id}/run"]

  retry = {
    error_message_regex = [
      "Too many requests"
    ]
  }

  timeouts {
    read = "10m"
  }
}

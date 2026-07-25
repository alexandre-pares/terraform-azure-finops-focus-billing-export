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

  timeouts {
    create = "5m"
    read   = "5m"
    update = "5m"
    delete = "5m"
  }
}

/* ------------------------------ Backfill job ------------------------------ */
resource "azapi_resource_action" "backfill_job" {
  for_each = local.months_to_backfill

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
    create = "5m"
    read   = "5m"
    update = "5m"
    delete = "5m"
  }
}

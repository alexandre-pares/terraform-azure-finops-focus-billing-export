output "export_resource_id" {
  description = <<DESCRIPTION
  Id of the export.

  Example:

  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-mpa-00000000-0000-4000-0000-0000`

  DESCRIPTION

  value = module.finops_focus_billing_export.resource_id
}

output "months_backfilled" {
  description = <<DESCRIPTION
  Map of months to backfill, empty map will be returned if `var.enable_backfill` is `false`:

  - `start_date` Start date of the month aligned with RFC 3339
  - `end_date` End date of the month, aligned with RFC 3339

  Example if `var.start_date` is `2026-01`, `var.creation_date` is `2026-07-25` and `var.enable_backfill` is `true`:

  ```hcl
  {
    "2026-01" = {
      "end_date" = "2026-01-31T00:00:00Z"
      "start_date" = "2026-01-01T00:00:00Z"
    }
    "2026-02" = {
      "end_date" = "2026-02-28T00:00:00Z"
      "start_date" = "2026-02-01T00:00:00Z"
    }
    "2026-03" = {
      "end_date" = "2026-03-31T00:00:00Z"
      "start_date" = "2026-03-01T00:00:00Z"
    }
    "2026-04" = {
      "end_date" = "2026-04-30T00:00:00Z"
      "start_date" = "2026-04-01T00:00:00Z"
    }
    "2026-05" = {
      "end_date" = "2026-05-31T00:00:00Z"
      "start_date" = "2026-05-01T00:00:00Z"
    }
    "2026-06" = {
      "end_date" = "2026-06-30T00:00:00Z"
      "start_date" = "2026-06-01T00:00:00Z"
    }
    "2026-07" = {
      "end_date" = "2026-07-25T00:00:00Z"
      "start_date" = "2026-07-01T00:00:00Z"
    }
  }
  ```

  DESCRIPTION

  value = module.finops_focus_billing_export.months_to_backfill
}

output "storage_account_id" {
  description = <<DESCRIPTION
  Id of the storage account containing the FinOps FOCUS billing export.

  Example:

  - `/subscriptions/00000000-0000-4000-0000-000000000000/resourceGroups/rg-finops-focus-abcd/providers/Microsoft.Storage/storageAccounts/stfinopsfocusabcd`

  DESCRIPTION

  value = module.focus_billing_storage_account.resource_id
}

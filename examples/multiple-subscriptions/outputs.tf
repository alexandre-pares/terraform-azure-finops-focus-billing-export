output "export_resource_id" {
  description = <<DESCRIPTION
  Map of export Ids.

  Example:
  ```hcl
  {
    sub_1 = {
      id = "/subscriptions/00000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-00000000-0000-4000-0000-0000"
    },
    sub_2 = {
      id = "/subscriptions/10000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-10000000-0000-4000-0000-0000"
    }
  }
  ```

  DESCRIPTION

  value = { for k, v in module.finops_focus_billing_export : k => { id = v.resource_id } }
}

output "months_backfilled" {
  description = <<DESCRIPTION
  Map of of list of months backfilled by customer key.

  Example if
  - `var.start_date` is `2026-01`
  - `var.creation_date` is `2026-06-06`
  - `subscriptions` is a map as following:

  ```hcl
  {
    sub_1 = {
      id = "00000000-0000-4000-0000-000000000000"
    },
    sub_2 = {
      id = "10000000-0000-4000-0000-000000000000"
    }
  }
  ```

  Then the `months_backfilled` will be:

  ```hcl
  {
    sub_1 = {
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
    sub_2 = {
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
  }
  ```

  DESCRIPTION

  value = { for k, v in module.finops_focus_billing_export : k => v.months_to_backfill }
}

output "storage_account_id" {
  description = <<DESCRIPTION
  Id of the storage account containing the FinOps FOCUS billing export.

  Example:

  - `/subscriptions/00000000-0000-4000-0000-000000000000/resourceGroups/rg-finops-focus-abcd/providers/Microsoft.Storage/storageAccounts/stfinopsfocusabcd`

  DESCRIPTION

  value = module.focus_billing_storage_account.resource_id
}

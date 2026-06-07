output "export_resource_id" {
  description = <<DESCRIPTION
  Id of the export.

  Example:

  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-mca-00000000-0000-5000-3000-0000`

  DESCRIPTION

  value = module.finops_focus_billing_export.resource_id
}

output "months_backfilled" {
  description = <<DESCRIPTION
  List of months backfilled.

  Example if `var.start_date` is `2026-01` and `var.creation_date` is `2026-06-06`:

  ```hcl
  [
    {
      end_date   = "2026-01-31T00:00:00Z"
      start_date = "2026-01-01T00:00:00Z"
    }
    {
      end_date   = "2026-02-28T00:00:00Z"
      start_date = "2026-02-01T00:00:00Z"
    }
    {
      end_date   = "2026-03-31T00:00:00Z"
      start_date = "2026-03-01T00:00:00Z"
    }
    {
      end_date   = "2026-04-30T00:00:00Z"
      start_date = "2026-04-01T00:00:00Z"
    }
    {
      end_date   = "2026-05-31T00:00:00Z"
      start_date = "2026-05-01T00:00:00Z"
    }
    {
      end_date   = "2026-06-06T00:00:00Z"
      start_date = "2026-06-01T00:00:00Z"
    }
  ]
  ```

  DESCRIPTION

  value = module.finops_focus_billing_export.months_to_backfill
}

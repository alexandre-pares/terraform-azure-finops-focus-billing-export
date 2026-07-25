output "resource_id" {
  description = <<DESCRIPTION
  Id of the export.

  Examples:

  - `/subscriptions/00000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-00000000-0000-4000-0000-0000` - Subscription
  - `/providers/Microsoft.Billing/billingAccounts/000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-ea-000000` - Enterprise Agreement (EA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-mca-00000000-0000-5000-3000-0000` - Microsoft Customer Agreement (MCA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-mpa-00000000-0000-4000-0000-0000` - Microsoft Partner Agreement (MPA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/BillingProfiles/0000-0000-000-000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-billing-profile-0000-0000-000-00` - MCA or MPA's Billing profile
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/BillingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-invoice-section-0000-0000-000-00` - MCA or MPA's Invoice section
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/BillingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-invoice-section-00000000-0000-40` - MCA or MPA's Invoice section
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-csp-cutomer-00000000-0000-4000-0` - CSP Customer (via MPA)

  DESCRIPTION

  value = azapi_resource.focus_export.id
}

output "months_to_backfill" {
  description = <<DESCRIPTION
  Map of months to backfill, empty map will be returned if `var.enable_backfill` is `false`:

  - `start_date` Start date of the month aligned with RFC 3339
  - `end_date` End date of the month, aligned with RFC 3339

  Example if `var.start_date` is `2025-11`, `var.creation_date` is `2026-07-25` and `var.enable_backfill` is `true`:

  ```hcl
  {
    "2025-11" = {
      "end_date" = "2025-11-30T00:00:00Z"
      "start_date" = "2025-11-01T00:00:00Z"
    }
    "2025-12" = {
      "end_date" = "2025-12-31T00:00:00Z"
      "start_date" = "2025-12-01T00:00:00Z"
    }
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

  value = local.months_to_backfill
}

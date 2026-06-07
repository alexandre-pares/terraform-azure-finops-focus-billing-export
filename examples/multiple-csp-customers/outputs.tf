output "export_resource_ids" {
  description = <<DESCRIPTION
  Map of export Id.

  Example:
  ```hcl
  {
    customer_1 = {
      id = "/providers/Microsoft.Billing/billingAccounts/00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-csp-cutomer-00000000-0000-4000-0"
    },
    customer_2 = {
      id = "/providers/Microsoft.Billing/billingAccounts/00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/10000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-csp-cutomer-10000000-0000-4000-0"
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
  - `customers` is

  ```hcl
  {
    customer_1 = {
      id = "00000000-0000-4000-0000-000000000000"
    },
    customer_2 = {
      id = "00000000-0000-4000-0000-000000000000"
    }
  }
  ```

  Then the `months_backfilled` will be:

  ```hcl
  {
    customer_1 = [
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
    customer_2 = [
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
  }
  ```

  DESCRIPTION

  value = { for k, v in module.finops_focus_billing_export : k => v.months_to_backfill }
}

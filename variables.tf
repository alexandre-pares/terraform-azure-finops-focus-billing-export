variable "storage_account_id" {
  description = <<DESCRIPTION
  Id of the Storage Account.

  Example:

  - `/subscriptions/00000000-0000-4000-0000-000000000000/resourceGroups/rg-finops-focus-j524/providers/Microsoft.Storage/storageAccounts/stfinrandomid`

  DESCRIPTION

  type     = string
  nullable = false
}

variable "container_name" {
  description = <<DESCRIPTION
  Name of the container.

  Example:

  - `focus`

  DESCRIPTION

  type     = string
  nullable = false
}

variable "export_version" {
  description = <<DESCRIPTION
  Version of the FinOps FOCUS billing export.

  Learn more: https://learn.microsoft.com/en-us/azure/cost-management-billing/dataset-schema/cost-usage-details-focus

  Examples:

  - `1.2-preview`
  - `1.0`
  - `1.0r2`
  - `1.0-preview`

  DESCRIPTION

  type     = string
  nullable = false
}

variable "scope_id" {
  description = <<DESCRIPTION
  Id of the scope of of the FinOps FOCUS billing export.

  Can be a subscription, billing account, invoice section, CSP customer, etc.

  Examples:

  - `/subscriptions/00000000-0000-4000-0000-000000000000` - Subscription
  - `/providers/Microsoft.Billing/billingAccounts/000000`- Enterprise Agreement (EA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31` - Microsoft Customer Agreement (MCA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30` - Microsoft Partner Agreement (MPA)
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000` - MCA Billing profile
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/billingProfiles/00000000-0000-4000-0000-000000000000` - MPA Billing profile
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000` - MCA Invoice section
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/00000000-0000-4000-0000-000000000000` - MCA Invoice section
  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000` - CSP Customer (attached to a MPA)

  DESCRIPTION

  type     = string
  nullable = false
}

/* ------------------------------- Export Name ------------------------------ */
variable "name" {
  description = <<DESCRIPTION
  Name of the FinOps FOCUS billing export.

  Validation: Export name must be alphanumeric, without whitespace, and 3 to 64 characters in length.

  Example:

  - `focus-export-for-sub-63aa77b3-5e14-4c6d-a895-27f9d8443e37` (57 characters)

  DESCRIPTION

  type     = string
  nullable = false

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,64}$", var.name))
    error_message = "Export name must be alphanumeric, without whitespace, and 3 to 64 characters in length."
  }
}

variable "description" {
  description = <<DESCRIPTION
  Description of the FinOps FOCUS billing export.

  DESCRIPTION

  type     = string
  nullable = false
}

variable "directory" {
  description = <<-DESCRIPTION
  Directory to place the billing export in.

  Validation: Directory name cannot end with a forward slash(/) or dot(.)

  Example:

  - `subscription_63aa77b3-5e14-4c6d-a895-27f9d8443e37` with `63aa77b3-5e14-4c6d-a895-27f9d8443e37` being the subscription id

  DESCRIPTION

  type     = string
  nullable = false
}

variable "start_date" {
  description = <<-EOT
  Start date of the export.
  You can go as far as 7 years in the past.
  Date should be:
  - in the past
  - before `var.creation_date`
  - the first day of the month

  Learn more: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#data-retention-limits-by-dataset


  Examples:

  - `2022-05-01`
  - `2026-01-01`
  - `2026-06-01`

  EOT

  type     = string
  nullable = false

  validation {
    condition     = endswith(var.start_date, "-01")
    error_message = "Date should be in the past and it must be the first day of the month."
  }
}

variable "creation_date" {
  description = <<DESCRIPTION
  Creation date of the export.

  This will be used only to create the backfill months list if `enable_backfill` is set to `true`.

  Examples:

  - `2025-12-22`
  - `2026-01-05`
  - `2026-06-06`

  DESCRIPTION

  type     = string
  nullable = false
}

variable "end_date" {
  description = <<DESCRIPTION
  End date of the export.

  Validation: Date should be in the future and it must be the first day of the month.

  Example:

  - `2050-01-01`

  DESCRIPTION

  type     = string
  nullable = false

  validation {
    condition     = endswith(var.end_date, "-01")
    error_message = "Date should be in the future and must be the first day of the month. (e.g. if `creation_date` is `2026-06-07`, then `end_date` must be at least `2026-07-01` or any first day of the month in the future like `2040-01-01` or `2050-01-01`)"
  }
}

variable "enable_backfill" {
  description = <<DESCRIPTION
  Enable the export backfill.

  If set to `true`, the module willrequest backfill based on `var.start_date` and `car.creation_date`.

  This option is recommended rather than going via the Azure portal (portal.azure.com) as it's limited to 13 months and you need to request one month at a time (if 13 months then 13 requests) thus this module to automate this task.

  Please note that retention is limited to 7 years and a `var.start_date` older than the current date will fail.

  Learn more: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#data-retention-limits-by-dataset

  Examples:

  - `true`
  - `false`

  DESCRIPTION

  type     = bool
  nullable = false
}

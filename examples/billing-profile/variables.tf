variable "subscription_id" {
  description = <<DESCRIPTION
    Id of the subscription. THis is used to create the resource group and storage account not the export.

    Example:

    - `00000000-0000-4000-0000-000000000000`

    DESCRIPTION

  type     = string
  nullable = false
}

variable "tenant_id" {
  description = <<DESCRIPTION
    Id of the Azure tenant.

    DESCRIPTION

  type     = string
  nullable = false
}

variable "mca_id" {
  description = <<DESCRIPTION
    Id of the MCA billing account (used for the FinOps FOCUS billing export scope).

    Id can be found via the Azure Portal (portal.azure.com) via "Cost Management + Billing > Billing scopes > Select your MCA > Billing > Billing profiles > Select your Billing profile > Settings > Properties > Billing account id".

    Example:

    - `00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31`

    DESCRIPTION

  type     = string
  nullable = false
}

variable "billing_profile_id" {
  description = <<DESCRIPTION
    Id of the billing profile attached to `var.mca_id` (used for the FinOps FOCUS billing export scope).

    Id can be found via the Azure Portal (portal.azure.com) via "Cost Management + Billing > Billing scopes > Select your MCA > Billing > Billing profiles > Select your Billing profile > Settings > Properties > Billing profile ID".

    Example:

    - `0000-0000-000-000`
    - `00000000-0000-4000-0000-000000000000`

    DESCRIPTION

  type     = string
  nullable = false
}

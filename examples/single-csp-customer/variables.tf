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

variable "mpa_id" {
  description = <<DESCRIPTION
    Id of the Microsoft Partner Agreement (MPA) billing account (used for the FinOps FOCUS billing export scope).

    Id can be found via the Azure Portal (portal.azure.com) via "Cost Management + Billing > Billing scopes > Select your MPA > Settings > Properties > Billing account id".

    Example:

    - `00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30`

    DESCRIPTION

  type     = string
  nullable = false
}

variable "customer_id" {
  description = <<DESCRIPTION
    Id of the Customer attached to a Microsoft Partner Agreement (MPA) billing account (used for the FinOps FOCUS billing export scope).

    Id can be found via the Azure Portal (portal.azure.com) via "Cost Management + Billing > Billing scopes > Select your MPA > Billing > Select the Customer".
    Then extract from the url the customer Id "customers%2F00000000-0000-4000-0000-000000000000/scope/Customer" where "00000000-0000-4000-0000-000000000000" is your customer id.

    Alternatively, you can find the customer Id from the Microsoft Partner Center (partner.microsoft.com) if you have GDAP (Granular Delegated Admin Relationships) via "Customers > Administer > Search the customer > Microsoft ID"

    Example:

    - `00000000-0000-4000-0000-000000000000`

    DESCRIPTION

  type     = string
  nullable = false
}

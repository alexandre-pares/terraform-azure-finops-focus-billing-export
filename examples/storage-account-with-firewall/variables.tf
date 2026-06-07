variable "subscription_id" {
  description = <<DESCRIPTION
    Id of the subscription (used for the FinOps FOCUS billing export scope)

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

variable "ipv4_address" {
  description = <<DESCRIPTION
  IP address or range to be allowed access to the storage account.

  Example:

  - `123.123.123.123`

  DESCRIPTION

  type     = string
  nullable = false
}

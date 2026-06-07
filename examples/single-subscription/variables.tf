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

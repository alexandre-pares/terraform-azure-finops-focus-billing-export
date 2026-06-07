variable "subscription_id" {
  description = <<DESCRIPTION
    Id of the subscription (used to store the storage account, can be different from Ids from `var.subscriptions`)

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

variable "subscriptions" {
  description = <<DESCRIPTION
  A set of subscription ids (used for the FinOps FOCUS billing export scope).

  Example:

  ```hcl
  {
    "sub_1" = {
      id = "00000000-0000-4000-0000-000000000000"
    },
    "sub_2" = {
      id = "10000000-0000-4000-0000-000000000000"
    }
  }

  DESCRIPTION

  type = map(object({
    id = string
  }))
  nullable = false
}

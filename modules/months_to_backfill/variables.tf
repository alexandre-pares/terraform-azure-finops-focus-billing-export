/* ---------------------------- Export start date --------------------------- */
variable "start_date" {
  description = <<-EOT
  Start date of the export.
  You can go as far as 9 years in the past.

  Validation: Date should be in the past and must be the first day of the month.

  E.g.: `2024-01-01`
  EOT

  type     = string
  default  = "2020-01-01"
  nullable = false

  validation {
    condition     = endswith(var.start_date, "-01")
    error_message = "Date should be in the past and it must be the first day of the month."
  }
}

variable "creation_date" {
  description = <<-EOT
  Creation date of the export.

  E.g.: `2024-07-22`
  EOT

  type     = string
  nullable = false
}

/* ----------------------------- Export end date ---------------------------- */
variable "end_date" {
  description = <<-EOT
  End date of the export.

  Validation: Date should be in the future and it must be the first day of the month.

  E.g.: `2050-01-01`
  EOT

  type     = string
  default  = "2050-01-01"
  nullable = false

  validation {
    condition     = endswith(var.end_date, "-01")
    error_message = "Date should be in the future and it must be the first day of the month."
  }
}

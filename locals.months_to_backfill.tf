locals {
  # Extract year for var.start_date and var.creation_date
  #
  # Example:
  # "2026-04-01" => 2026
  # "2026-07-25" => 2026
  start_year    = tonumber(substr(var.start_date, 0, 4))
  creation_year = tonumber(substr(var.creation_date, 0, 4))

  # Convert months of var.start_date and var.creation_date to numbers to later compare them
  #
  # Example:
  # "2026-04-01" => 202604
  # "2026-07-25" => 202607
  start_month_num    = tonumber(replace(substr(var.start_date, 0, 7), "-", ""))
  creation_month_num = tonumber(replace(substr(var.creation_date, 0, 7), "-", ""))

  # List of months between var.start_date and var.creation_date
  #
  # Example:
  # ["2026-04", "2026-05", "2026-06", "2026-07"]
  months = [
    for month in flatten([
      for y in range(local.start_year, local.creation_year + 1) : [
        for m in range(1, 13) : format("%d-%02d", y, m)
      ]
    ]) : month
    if tonumber(replace(month, "-", "")) >= local.start_month_num && tonumber(replace(month, "-", "")) <= local.creation_month_num
  ]

  # Map of months to backfill
  # - `start_date` Start date of the month aligned with RFC 3339
  # - `end_date` End date of the month, aligned with RFC 3339
  #
  # Example:
  # {
  #   "2026-04" = {
  #     "start_date" = "2026-04-01T00:00:00Z"
  #     "end_date"   = "2026-04-30T00:00:00Z"
  #   }
  #   "2026-05" = {
  #     "start_date" = "2026-05-01T00:00:00Z"
  #     "end_date"   = "2026-05-31T00:00:00Z"
  #   }
  #   "2026-06" = {
  #     "start_date" = "2026-06-01T00:00:00Z"
  #     "end_date"   = "2026-06-30T00:00:00Z"
  #   }
  #   "2026-07" = {
  #     "start_date" = "2026-07-01T00:00:00Z"
  #     "end_date"   = "2026-07-25T00:00:00Z" # because end_date cannot be in the future, so it's reduced to var.creation_date
  #   }
  # }
  #
  # Learn more: https://developer.hashicorp.com/terraform/language/functions/formatdate#specification-syntax
  months_to_backfill = var.enable_backfill ? merge(
    {
      for month in local.months : month => {
        start_date = "${month}-01T00:00:00Z"

        # Calculates end of month by adding 31 days to step into next month,
        # rounding down to 1st of next month, and subtracting 1 second to get last day of previous month
        end_date = formatdate(
          "YYYY-MM-DD'T'00:00:00Z",
          timeadd(
            formatdate("YYYY-MM-01'T'00:00:00Z", timeadd("${month}-01T00:00:00Z", "744h")), # +31 days (24h*31d)
            "-1s"
          )
        )
      }
    },
    {
      substr(var.creation_date, 0, 7) = {
        start_date = "${substr(var.creation_date, 0, 7)}-01T00:00:00Z"
        end_date   = "${var.creation_date}T00:00:00Z"
      }
    }
  ) : {}
}

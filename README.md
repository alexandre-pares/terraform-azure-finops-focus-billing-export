# FinOps FOCUS billing export Terraform module for Microsoft Azure

Terraform Module to create FOCUS billing exports for Azure. Supports EA, MCA and MPA billing accounts types. FOCUS billing exports can also be created at the subscription level.

## What is FOCUS™?

The FinOps Cost and Usage Specification (FOCUS™) is an open-source specification that defines clear requirements for cloud vendors to produce consistent cost and usage datasets.

Supported by the FinOps Foundation, FOCUS™ aims to reduce complexity for FinOps Practitioners so they can drive data-driven decision-making and maximize the business value of cloud, while making their skills more transferable across clouds, tools, and organizations.

Learn more about FOCUS in this [FinOps Foundation Insights article](https://www.finops.org/insights/focus-1-0-available/).

## Supported scopes:

- Enterprise Agreement (EA): Billing account, department and enrollment
- Microsoft Customer Agreement (MCA), including MCA enterprise (MCA-E): Billing account, billing profile and invoice section
- Microsoft Partner Agreement (MPA): Billing account, customer and billing profile
- Subscription and resource group

[-> Learn more about supported scopes](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#understand-export-data-types)

## Supported FOCUS versions

[FOCUS v1.2](https://github.com/FinOps-Open-Cost-and-Usage-Spec/FOCUS_Spec/releases/tag/v1.2) billing export is now now available on Azure!

- `1.2-preview`
- `1.0r2`
- `1.0`
- `1.0-preview`

[-> Learn more about Azure FOCUS export versions](https://learn.microsoft.com/en-us/azure/cost-management-billing/dataset-schema/cost-usage-details-focus)

Microsoft is not 100% aligned with the FOCUS specification, therefore we recommend to check [the conformance gap report](https://learn.microsoft.com/en-us/cloud-computing/finops/focus/conformance-full-report).

## Usage

Detailed examples are available under the [`./examples`](./examples/) directory.

```hcl
module "finops_focus_billing_export" {
  source  = "alexandre-pares/finops-focus-billing-export/azure"
  version = "2.1.0"

  name           = substr("finops-focus-billing-export-for-sub-${var.subscription_id}", 0, 64)
  description    = "FinOps FOCUS billing export for subscription ${var.subscription_id}"
  export_version = "1.2-preview"
  scope_id       = "/subscriptions/${var.subscription_id}"

  storage_account_id = module.focus_billing_storage_account.resource_id
  container_name     = "focus"

  directory = "v1.2-preview/sub_${var.subscription_id}"

  creation_date = "2026-06-07"
  start_date    = "2026-01-01"
  end_date      = "2050-01-01"

  enable_backfill = true
}
```

## Limitations

- Id of backfill jobs is not returned by the [microsoft API](https://learn.microsoft.com/en-us/rest/api/cost-management/exports/execute) on job submission, therefore returned id is incorrect

## Common errors

### FocusCost is not supported

<details>

<summary>FocusCost is not supported</summary>

```bash
╷
│ Error: Failed to create/update resource
│
│   with module.azurerm_billing_export.azapi_resource.focus_export[0],
│   on ../../main.tf line 100, in resource "azapi_resource" "focus_export":
│  100: resource "azapi_resource" "focus_export" {
│
│ creating/updating Resource: (ResourceId
│ "/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx"
│ / Api Version "2023-07-01-preview"): PUT
│ https://management.azure.com/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx
│ --------------------------------------------------------------------------------
│ RESPONSE 400: 400 Bad Request
│ ERROR CODE: BadRequest
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "BadRequest",
│     "message": "Request properties validation failed: Export type: FocusCost is not supported for Agreement Type: WebDirect and Subscription."
│   }
│ }
│ --------------------------------------------------------------------------------
│
╵
```

</details>

Check if your subscription type is supported here: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#understand-data-types

### RP Not Registered

<details>

<summary>RP Not Registered</summary>

```bash
╷
│ Error: Failed to create/update resource
│
│   with module.azurerm_billing_export.azapi_resource.focus_export[0],
│   on .terraform/modules/azurerm_billing_export/main.tf line 76, in resource "azapi_resource" "focus_export":
│   76: resource "azapi_resource" "focus_export" {
│
│ creating/updating Resource: (ResourceId
│ "/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx"
│ / Api Version "2023-07-01-preview"): PUT
│ https://management.azure.com/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/focus-export-for-subscription-xxxx-xxxx-xxxx-xxxx
│ --------------------------------------------------------------------------------
│ RESPONSE 400: 400 Bad Request
│ ERROR CODE: 400
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "400",
│     "message": "RP Not Registered. Register destination storage account subscription with Microsoft.CostManagementExports. Please refer https://docs.microsoft.com/en-us/rest/api/resources/providers/register"
│   }
│ }
│ --------------------------------------------------------------------------------
│
╵
```

</details>

Register `Microsoft.CostManagementExports` from the source subscription.

### Invalid definition timePeriod

<details>

<summary>Invalid definition timePeriod</summary>

```bash
╷
│ Error: Failed to perform action
│
│   with module.finops_focus_billing_export.azapi_resource_action.backfill_job["2026-07"],
│   on ../../main.tf line 78, in resource "azapi_resource_action" "backfill_job":
│   78: resource "azapi_resource_action" "backfill_job" {
│
│ performing action run of "Resource: (ResourceId \"/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-xxxx-xxxx-xxxx-xxxx\" / Api Version \"2023-07-01-preview\")": POST
│ https://management.azure.com/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-xxxx-xxxx-xxxx-xxxx/run
│ --------------------------------------------------------------------------------
│ RESPONSE 400: 400 Bad Request
│ ERROR CODE: BadRequest
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "BadRequest",
│     "message": "Request properties validation failed: Invalid definition timePeriod; 'to' value cannot be in the future."
│   }
│ }
│ --------------------------------------------------------------------------------
│
╵
```

</details>

Check `var.creation_date` and `var.start_date`. They should not be greater that the current date.

### context deadline exceeded

<details>

<summary>context deadline exceeded</summary>

```bash
[...]
module.finops_focus_billing_export.azapi_resource.focus_export: Still creating... [04m53s elapsed]
module.finops_focus_billing_export.azapi_resource.focus_export: Still creating... [05m06s elapsed]
module.finops_focus_billing_export.azapi_resource.focus_export: Still creating... [05m16s elapsed]
╷
│ Error: Failed to create/update resource
│
│   with module.finops_focus_billing_export.azapi_resource.focus_export,
│   on ../../main.tf line 1, in resource "azapi_resource" "focus_export":
│    1: resource "azapi_resource" "focus_export" {
│
│ creating/updating Resource: (ResourceId "/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-xxxx-xxxx-xxxx-xxxx" / Api Version "2023-07-01-preview"): context deadline
│ exceeded
╵
```

</details>

This can happen when the Azure Cost Management API endpoint is blocked (e.g. by your corporate proxy) as FinOps FOCUS export creation should only takes a few seconds to create.

Add `costmanagement.trafficmanager.net` to your proxy allowlist. (This is because the `Microsoft.CostManagement/exports@2023-07-01-preview` API will return a `Location` header on PUT request that point to `https://costmanagement.trafficmanager.net/***`)

Additionally, you can enable Terraform debugs's logs to investigate the issues.

```bash
# Enable Terraform debug Logs
# Learn more: https://developer.hashicorp.com/terraform/internals/debugging
export TF_LOG="DEBUG"

# Set TF log to default verbosity
export TF_LOG=""
```

Sadly, even if the `costmanagement.trafficmanager.net` URL is blocked, the FinOps FOCUS export will be created and you will encounter an additional error once the URL is whitelisted once you apply again the Teraform:

```bash
╷
│ Error: Resource already exists
│
│   with module.finops_focus_billing_export.azapi_resource.focus_export,
│   on ../../main.tf line 1, in resource "azapi_resource" "focus_export":
│    1: resource "azapi_resource" "focus_export" {
│
│ a resource with the ID "/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-xxxx-xxxx-xxxx-xxxx" already exists - to be managed via Terraform this resource needs to be
│ imported into the State. Please see the resource documentation for "azapi_resource" for more information
╵
```

You can either import it using Terraform or manually delete it from the Azure Portal and apply again the Terraform.

To import, add the following code to your `main.tf`.

```hcl
import {
  to = module.finops_focus_billing_export.azapi_resource.focus_export
  identity = {
    id   = "/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-xxxx-xxxx-xxxx-xxxx"
    type = "Microsoft.CostManagement/exports@2023-07-01-preview"
  }
}
```

Once imported, you can safely remove the import block.

### An export is already in progress

<details>

<summary>An export is already in progress</summary>

```bash
╷
│ Error: Failed to perform action
│
│   with module.finops_focus_billing_export.azapi_resource_action.backfill_job["2026-06"],
│   on ../../main.tf line 71, in resource "azapi_resource_action" "backfill_job":
│   71: resource "azapi_resource_action" "backfill_job" {
│
│ performing action run of "Resource: (ResourceId \"/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-4-sub-xxxx-xxxx-xxxx-xxxx\" / Api Version \"2023-07-01-preview\")": POST
│ https://management.azure.com/subscriptions/xxxx-xxxx-xxxx-xxxx/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-4-sub-xxxx-xxxx-xxxx-xxxx/run
│ --------------------------------------------------------------------------------
│ RESPONSE 409: 409 Conflict
│ ERROR CODE: Conflict
│ --------------------------------------------------------------------------------
│ {
│   "error": {
│     "code": "Conflict",
│     "message": "An export is already in progress. Please wait for the current export to complete before starting a new one."
│   }
│ }
│ --------------------------------------------------------------------------------
│
╵
```

</details>

This can happen you try to update the `var.creation_date` with a new value in the same month than the previous value.

To fix this, you can either:
- wait for the backfill job to succeed and apply again the Terraform or
- recreate the export again as this error only happen when creating new exports
- revert the value of `var.creation_date` to it's previous state and manually run the export for the current month using the Azure Portal

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.8 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.10 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.10 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [azapi_resource.focus_export](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource_action.backfill_job](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource_action) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container.<br/><br/>  Example:<br/><br/>  - `focus` | `string` | n/a | yes |
| <a name="input_creation_date"></a> [creation\_date](#input\_creation\_date) | Creation date of the export.<br/><br/>  This will be used only to create the backfill months list if `enable_backfill` is set to `true`.<br/><br/>  Examples:<br/><br/>  - `2025-12-22`<br/>  - `2026-01-05`<br/>  - `2026-06-06` | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the FinOps FOCUS billing export. | `string` | n/a | yes |
| <a name="input_directory"></a> [directory](#input\_directory) | Directory to place the billing export in.<br/><br/>Validation: Directory name cannot end with a forward slash(/) or dot(.)<br/><br/>Example:<br/><br/>- `subscription_63aa77b3-5e14-4c6d-a895-27f9d8443e37` with `63aa77b3-5e14-4c6d-a895-27f9d8443e37` being the subscription id | `string` | n/a | yes |
| <a name="input_enable_backfill"></a> [enable\_backfill](#input\_enable\_backfill) | Enable the export backfill.<br/><br/>  If set to `true`, the module willrequest backfill based on `var.start_date` and `car.creation_date`.<br/><br/>  This option is recommended rather than going via the Azure portal (portal.azure.com) as it's limited to 13 months and you need to request one month at a time (if 13 months then 13 requests) thus this module to automate this task.<br/><br/>  Please note that retention is limited to 7 years and a `var.start_date` older than the current date will fail.<br/><br/>  Learn more: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#data-retention-limits-by-dataset<br/><br/>  Examples:<br/><br/>  - `true`<br/>  - `false` | `bool` | n/a | yes |
| <a name="input_end_date"></a> [end\_date](#input\_end\_date) | End date of the export.<br/><br/>  Validation: Date should be in the future and it must be the first day of the month.<br/><br/>  Example:<br/><br/>  - `2050-01-01` | `string` | n/a | yes |
| <a name="input_export_version"></a> [export\_version](#input\_export\_version) | Version of the FinOps FOCUS billing export.<br/><br/>  Learn more: https://learn.microsoft.com/en-us/azure/cost-management-billing/dataset-schema/cost-usage-details-focus<br/><br/>  Examples:<br/><br/>  - `1.2-preview`<br/>  - `1.0`<br/>  - `1.0r2`<br/>  - `1.0-preview` | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the FinOps FOCUS billing export.<br/><br/>  Validation: Export name must be alphanumeric, without whitespace, and 3 to 64 characters in length.<br/><br/>  Example:<br/><br/>  - `focus-export-for-sub-63aa77b3-5e14-4c6d-a895-27f9d8443e37` (57 characters) | `string` | n/a | yes |
| <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id) | Id of the scope of of the FinOps FOCUS billing export.<br/><br/>  Can be a subscription, billing account, invoice section, CSP customer, etc.<br/><br/>  Examples:<br/><br/>  - `/subscriptions/00000000-0000-4000-0000-000000000000` - Subscription<br/>  - `/providers/Microsoft.Billing/billingAccounts/000000`- Enterprise Agreement (EA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31` - Microsoft Customer Agreement (MCA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30` - Microsoft Partner Agreement (MPA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000` - MCA Billing profile<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/billingProfiles/00000000-0000-4000-0000-000000000000` - MPA Billing profile<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000` - MCA Invoice section<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/billingProfiles/0000-0000-000-000/invoiceSections/00000000-0000-4000-0000-000000000000` - MCA Invoice section<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000` - CSP Customer (attached to a MPA) | `string` | n/a | yes |
| <a name="input_start_date"></a> [start\_date](#input\_start\_date) | Start date of the export.<br/>You can go as far as 7 years in the past.<br/>Date should be:<br/>- in the past<br/>- before `var.creation_date`<br/>- the first day of the month<br/><br/>Learn more: https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/tutorial-improved-exports#data-retention-limits-by-dataset<br/><br/><br/>Examples:<br/><br/>- `2022-05-01`<br/>- `2026-01-01`<br/>- `2026-06-01` | `string` | n/a | yes |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | Id of the Storage Account.<br/><br/>  Example:<br/><br/>  - `/subscriptions/00000000-0000-4000-0000-000000000000/resourceGroups/rg-finops-focus-j524/providers/Microsoft.Storage/storageAccounts/stfinrandomid` | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_months_to_backfill"></a> [months\_to\_backfill](#output\_months\_to\_backfill) | Map of months to backfill, empty map will be returned if `var.enable_backfill` is `false`:<br/><br/>  - `start_date` Start date of the month aligned with RFC 3339<br/>  - `end_date` End date of the month, aligned with RFC 3339<br/><br/>  Example if `var.start_date` is `2025-11`, `var.creation_date` is `2026-07-25` and `var.enable_backfill` is `true`:<pre>hcl<br/>  {<br/>    "2025-11" = {<br/>      "end_date" = "2025-11-30T00:00:00Z"<br/>      "start_date" = "2025-11-01T00:00:00Z"<br/>    }<br/>    "2025-12" = {<br/>      "end_date" = "2025-12-31T00:00:00Z"<br/>      "start_date" = "2025-12-01T00:00:00Z"<br/>    }<br/>    "2026-01" = {<br/>      "end_date" = "2026-01-31T00:00:00Z"<br/>      "start_date" = "2026-01-01T00:00:00Z"<br/>    }<br/>    "2026-02" = {<br/>      "end_date" = "2026-02-28T00:00:00Z"<br/>      "start_date" = "2026-02-01T00:00:00Z"<br/>    }<br/>    "2026-03" = {<br/>      "end_date" = "2026-03-31T00:00:00Z"<br/>      "start_date" = "2026-03-01T00:00:00Z"<br/>    }<br/>    "2026-04" = {<br/>      "end_date" = "2026-04-30T00:00:00Z"<br/>      "start_date" = "2026-04-01T00:00:00Z"<br/>    }<br/>    "2026-05" = {<br/>      "end_date" = "2026-05-31T00:00:00Z"<br/>      "start_date" = "2026-05-01T00:00:00Z"<br/>    }<br/>    "2026-06" = {<br/>      "end_date" = "2026-06-30T00:00:00Z"<br/>      "start_date" = "2026-06-01T00:00:00Z"<br/>    }<br/>    "2026-07" = {<br/>      "end_date" = "2026-07-25T00:00:00Z"<br/>      "start_date" = "2026-07-01T00:00:00Z"<br/>    }<br/>  }</pre> |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | Id of the export.<br/><br/>  Examples:<br/><br/>  - `/subscriptions/00000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-sub-00000000-0000-4000-0000-0000` - Subscription<br/>  - `/providers/Microsoft.Billing/billingAccounts/000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-ea-000000` - Enterprise Agreement (EA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-mca-00000000-0000-5000-3000-0000` - Microsoft Customer Agreement (MCA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-mpa-00000000-0000-4000-0000-0000` - Microsoft Partner Agreement (MPA)<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/BillingProfiles/0000-0000-000-000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-billing-profile-0000-0000-000-00` - MCA or MPA's Billing profile<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/BillingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-invoice-section-0000-0000-000-00` - MCA or MPA's Invoice section<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-5000-3000-000000000000:00000000-0000-4000-0000-000000000000_2019-05-31/BillingProfiles/0000-0000-000-000/invoiceSections/0000-0000-000-000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-invoice-section-00000000-0000-40` - MCA or MPA's Invoice section<br/>  - `/providers/Microsoft.Billing/billingAccounts/00000000-0000-4000-0000-000000000000:00000000-0000-4000-0000-000000000000_2018-09-30/customers/00000000-0000-4000-0000-000000000000/providers/Microsoft.CostManagement/exports/finops-focus-billing-export-for-csp-cutomer-00000000-0000-4000-0` - CSP Customer (via MPA) |
<!-- END_TF_DOCS -->

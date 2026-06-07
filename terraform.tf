terraform {
  required_version = "~> 1.8"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.10"
    }
    # tflint-ignore: terraform_unused_required_providers
    time = {
      source  = "hashicorp/time"
      version = "~> 0.14"
    }
  }
}

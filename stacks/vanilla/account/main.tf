terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50.0"
    }
  }
}

provider "aws" {
  region = var.default_region
}

variable "account_name" { type = string }
variable "ou_name" { type = string }
variable "extra_allowed_regions" {
  type    = list(string)
  default = []
}

module "org" {
  source = "../../../modules/organizations-vanilla"
  ou_structure = {
    InfoSec        = { name = "InfoSec" }
    Sandbox        = { name = "Sandbox" }
    Shared         = { name = "Shared" }
    Development    = { name = "Development" }
    Staging        = { name = "Staging" }
    Pre-Production = { name = "Pre-Production" }
    Production     = { name = "Production" }
  }
}

module "restrict_regions" {
  source                = "../../../stacks/shared/restrict-regions"
  extra_allowed_regions = var.extra_allowed_regions
  # Attach to root by default; you can scope to OU or account if desired.
  attach_to_root = true
}

variable "default_region" {
  type    = string
  default = "us-east-1"
}

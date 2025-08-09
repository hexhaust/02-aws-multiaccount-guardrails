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

variable "default_region" {
  type    = string
  default = "us-east-1"
}

variable "base_allowed_regions" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "ap-northeast-1", "ap-southeast-1", "eu-central-1"]
}

variable "extra_allowed_regions" {
  type    = list(string)
  default = []
}

variable "target_ou_ids" {
  type    = list(string)
  default = []
}

variable "target_account_ids" {
  type    = list(string)
  default = []
}

variable "attach_to_root" {
  type    = bool
  default = true
}

locals {
  # from stacks/shared/restrict-regions -> repo root is ../../../
  policy_json = templatefile(
    "${path.module}/../../../policies/scp/restrict-regions.tpl.json",
    {
      allowed_regions = jsonencode(concat(var.base_allowed_regions, var.extra_allowed_regions))
    }
  )
}

module "scp" {
  source             = "../../../modules/scp"
  name               = "restrict-regions"
  description        = "Deny actions outside approved regions (with per-account override)."
  policy_json        = local.policy_json
  attach_to_root     = var.attach_to_root
  target_ou_ids      = var.target_ou_ids
  target_account_ids = var.target_account_ids
}

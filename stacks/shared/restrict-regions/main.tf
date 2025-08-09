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

data "template_file" "policy" {
  template = file("${path.module}/../../policies/scp/restrict-regions.tpl.json")
  vars = {
    base_allowed_regions  = jsonencode(var.base_allowed_regions)
    extra_allowed_regions = jsonencode(var.extra_allowed_regions)
  }
}

module "scp" {
  source             = "../../modules/scp"
  name               = "restrict-regions"
  description        = "Deny actions outside approved regions (with per-account override)."
  policy_json        = data.template_file.policy.rendered
  attach_to_root     = var.attach_to_root
  target_ou_ids      = var.target_ou_ids
  target_account_ids = var.target_account_ids
}

variable "default_region" {
  type    = string
  default = "us-east-1"
}

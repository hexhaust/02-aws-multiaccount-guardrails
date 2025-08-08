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

variable "security_account_id" { type = string, default = "000000000000" }
variable "log_archive_bucket_name" { type = string, default = "org-cloudtrail-logs" }

module "guardduty_admin" {
  source  = "terraform-aws-modules/guardduty/aws"
  version = "~> 5.0"

  enable_organization_admin_account = true
  admin_account_id = var.security_account_id
  enable_organization = true
}

variable "default_region" { type = string, default = "us-east-1" }

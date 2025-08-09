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

# Delegated admin account for GuardDuty (InfoSec)
variable "security_account_id" {
  type    = string
  default = "000000000000"
}

# NOTE: This resource must be applied from the Organization management account.
# For CI 'validate' it’s fine; real apply will need proper creds/context.
resource "aws_guardduty_organization_admin_account" "this" {
  admin_account_id = var.security_account_id
}

output "guardduty_admin_account" {
  value = aws_guardduty_organization_admin_account.this.admin_account_id
}

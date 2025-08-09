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

# Delegated admin account for Security Hub (InfoSec)
variable "security_account_id" {
  type    = string
  default = "000000000000"
}

# Must be run from the Org management account in real life.
resource "aws_securityhub_organization_admin_account" "this" {
  admin_account_id = var.security_account_id
}

output "securityhub_admin_account" {
  value = aws_securityhub_organization_admin_account.this.admin_account_id
}

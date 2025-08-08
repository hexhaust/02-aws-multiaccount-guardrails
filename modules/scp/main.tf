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


resource "aws_organizations_policy" "this" {
  name        = var.name
  description = var.description
  type        = "SERVICE_CONTROL_POLICY"
  content     = var.policy_json
}

# Attachments
resource "aws_organizations_policy_attachment" "root" {
  count     = var.attach_to_root ? 1 : 0
  policy_id = aws_organizations_policy.this.id
  target_id = data.aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_policy_attachment" "ous" {
  for_each  = toset(var.target_ou_ids)
  policy_id = aws_organizations_policy.this.id
  target_id = each.value
}

resource "aws_organizations_policy_attachment" "accounts" {
  for_each  = toset(var.target_account_ids)
  policy_id = aws_organizations_policy.this.id
  target_id = each.value
}

data "aws_organizations_organization" "org" {}
variable "default_region" { type = string, default = "us-east-1" }

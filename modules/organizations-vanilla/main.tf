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


data "aws_organizations_organization" "org" { }

resource "aws_organizations_organizational_unit" "ou" {
  for_each = var.ou_structure
  name     = each.value.name
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

output "ou_ids" {
  value = {
    for k, v in aws_organizations_organizational_unit.ou :
    k => v.id
  }
}

variable "default_region" { type = string, default = "us-east-1" }

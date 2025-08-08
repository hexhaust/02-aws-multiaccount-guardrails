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

# Look up existing CT-created OUs by name; create if missing (idempotent via importable resource is hard),
# so here we only *read* and expect OUs to exist. In vanilla stack we create OUs.
data "aws_organizations_organizational_units" "root_children" {
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

locals {
  ou_name_to_id = {
    for ou in data.aws_organizations_organizational_units.root_children.children :
    ou.name => ou.id
  }
}

output "ou_ids" {
  value = {
    for k, v in var.ou_structure :
    k => try(local.ou_name_to_id[v.name], null)
  }
}

variable "default_region" { type = string, default = "us-east-1" }

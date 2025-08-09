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

variable "security_account_id" {
  type    = string
  default = "000000000000"
}

resource "aws_config_configuration_aggregator" "org" {
  name = "org-aggregator"

  organization_aggregation_source {
    all_regions = true
  }
}

output "config_aggregator_arn" {
  value = aws_config_configuration_aggregator.org.arn
}

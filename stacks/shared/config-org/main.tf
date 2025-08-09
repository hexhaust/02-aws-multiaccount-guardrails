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

variable "config_aggregator_role_arn" {
  description = "IAM Role ARN that AWS Config uses for the organization aggregator (e.g., arn:aws:iam::<InfoSecAccountId>:role/OrgConfigAggregatorRole)"
  type        = string
  default     = "arn:aws:iam::000000000000:role/OrgConfigAggregatorRole"
}

resource "aws_config_configuration_aggregator" "org" {
  name = "org-aggregator"

  organization_aggregation_source {
    all_regions = true
    role_arn    = var.config_aggregator_role_arn
  }
}

output "config_aggregator_arn" {
  value = aws_config_configuration_aggregator.org.arn
}

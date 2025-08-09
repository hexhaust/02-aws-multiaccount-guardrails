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

# InfoSec (delegated admin) account ID — used by you operationally, not strictly needed here.
variable "security_account_id" {
  type    = string
  default = "000000000000"
}

# Organization-wide AWS Config Aggregator
resource "aws_config_configuration_aggregator" "org" {
  name = "org-aggregator"

  organization_aggregation_source {
    all_regions = true
    # If you want to scope to specific regions:
    # regions = ["us-east-1", "us-west-2"]
  }
}

output "config_aggregator_arn" {
  value = aws_config_configuration_aggregator.org.arn
}

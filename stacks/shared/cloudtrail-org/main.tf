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

module "cloudtrail" {
  source  = "terraform-aws-modules/cloudtrail/aws"
  version = "~> 5.4"

  name                          = "org-trail"
  is_organization_trail         = true
  enable_log_file_validation    = true
  include_global_service_events = true
  is_multi_region_trail         = true

  s3_bucket_name = var.log_archive_bucket_name
}

variable "default_region" {
  type    = string
  default = "us-east-1"
}

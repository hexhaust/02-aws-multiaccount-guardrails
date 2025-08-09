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

# Inputs kept for symmetry with other stacks (security account may own the bucket/KMS)
variable "security_account_id" {
  type    = string
  default = "000000000000"
}

variable "log_archive_bucket_name" {
  type    = string
  default = "org-cloudtrail-logs"
}

# Minimal org-wide CloudTrail (assumes bucket exists)
resource "aws_cloudtrail" "org" {
  name                          = "org-trail"
  is_organization_trail         = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_log_file_validation    = true

  s3_bucket_name = var.log_archive_bucket_name

  # If you later add a KMS key, uncomment:
  # kms_key_id     = "arn:aws:kms:...:key/..."
  # enable_log_file_validation = true
}

output "trail_arn" {
  value = aws_cloudtrail.org.arn
}

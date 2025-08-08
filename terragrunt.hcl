# Root Terragrunt config
locals {
  landing_zone_flavor = get_env("LZ_FLAVOR", "control-tower") # or "vanilla"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "CHANGE-ME-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "CHANGE-ME-tflock"
  }
}

include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

locals {
  # Choose stack flavor:
  # - control-tower: stacks/control-tower
  # - vanilla:       stacks/vanilla
  landing_zone_flavor = local.landing_zone_flavor != "" ? local.landing_zone_flavor : "control-tower"
}

terraform {
  source = "../../../stacks/{local.landing_zone_flavor}//account"
}

inputs = {
  account_name           = "example-account"
  ou_name                = "Pre-Production"
  extra_allowed_regions  = []  # <-- per-account override here
  default_region         = "us-east-1"
}

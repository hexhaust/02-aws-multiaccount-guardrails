include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

locals {
  ou_name = "Sandbox"
}

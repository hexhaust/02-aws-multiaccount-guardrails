variable "name" { type = string }
variable "description" { type = string }
variable "policy_json" { type = string }

variable "attach_to_root" {
  type    = bool
  default = false
}

variable "target_ou_ids" {
  type    = list(string)
  default = []
}

variable "target_account_ids" {
  type    = list(string)
  default = []
}

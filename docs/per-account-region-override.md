# Per-account region override

1. Open the account's `envs/<OU>/<account>/terragrunt.hcl`.
2. Add or extend:
```hcl
inputs = {
  extra_allowed_regions = ["eu-west-1","ap-south-1"]
}
```
3. Commit and open a PR. After approval and merge, Terragrunt apply will update the SCP.

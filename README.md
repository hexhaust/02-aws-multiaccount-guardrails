# 🛡️ Production-ready guardrails for an AWS multi-account organization using **Terraform + Terragrunt**.

## Landing Zone Flavors

This repo supports **both**:
1) **Control Tower–aligned** (`stacks/control-tower/*`) — assumes CT is deployed and manages baseline OUs/accounts, while this repo manages guardrails, services and attachments.
2) **Vanilla Terraform** (`stacks/vanilla/*`) — creates/manages Organizations, OUs, and guardrails without Control Tower.

Choose per environment by pointing Terragrunt `source` to the desired stack.

## 🏢 OU Layout

- **InfoSec** (delegated admin for GuardDuty, Security Hub, Config aggregator, Access Analyzer)
- **Sandbox**
- **Shared**
- **Development**
- **Staging**
- **Pre-Production**
- **Production**

## 🚧 Region Restriction (SCP)

Default allowed regions: `us-east-1`, `us-west-2`, `ap-northeast-1`, `ap-southeast-1`, `eu-central-1`.

Per-account overrides are supported via Terragrunt input `extra_allowed_regions` in each account's `terragrunt.hcl`. Submit a PR adding regions for that account and CI will generate the merged SCP.

## 🔐 Security Services (Org-wide)

- **CloudTrail (Org Trail)** with KMS + S3 in Log Archive
- **AWS Config** aggregator in InfoSec
- **GuardDuty** delegated admin + auto-enable to all accounts
- **Security Hub** standards: AWS Foundational Best Practices + CIS 1.4
- **Access Analyzer** at org-level
- **Identity Center** permission sets (starter set)

## ✔️ Optional: Pre-commit hooks

You can optionally install `pre-commit` hooks to auto-run Terraform lint, security checks, and OPA tests before each commit:

```bash
pip install pre-commit
pre-commit install
```

## Getting Started

```bash
# 1) Enable pre-commit (optional)
pip install pre-commit && pre-commit install

# 2) Navigate to an env and run a plan
cd envs/org-root
terragrunt run-all plan

# 3) Apply with approvals
terragrunt run-all apply
```

## Per-account region override

Example in `envs/Production/app1/terragrunt.hcl`:
```hcl
inputs = {
  extra_allowed_regions = ["eu-west-1"]
}
```
The final policy will allow base + extra list for that account only.

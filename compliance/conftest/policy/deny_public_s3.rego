package policy

deny[msg] {
  input.resource_type == "aws_s3_bucket"
  public := input.public
  public == true
  msg := sprintf("Public S3 bucket found: %s", [input.name])
}

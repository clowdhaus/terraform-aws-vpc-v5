provider "aws" {
  region = local.region
}

locals {
  region = "eu-west-1"
}

module "state_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 2.14"

  bucket = "terraform-aws-vpc-v4"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled = true
  }
}

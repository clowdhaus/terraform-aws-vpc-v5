terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.5"
    }
  }

  # Used to aid in diffing across v4/v5 in separate folders
  backend "s3" {
    bucket = "terraform-aws-vpc-v5"
    key    = "ipv6/terraform.tfstate"
    region = "eu-west-1"
  }
}

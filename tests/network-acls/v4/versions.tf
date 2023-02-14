terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }

  # Used to aid in diffing across v4/v5 in separate folders
  backend "s3" {
    bucket = "terraform-aws-vpc-v5"
    key    = "network-acls/terraform.tfstate"
    region = "eu-west-1"
  }
}

terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.5"
    }
  }

  # Used to aid in diffing across v6/v7 in separate folders
  backend "s3" {
    bucket = "terraform-aws-vpc-v7"
    key    = "network-acls/terraform.tfstate"
    region = "eu-west-1"
  }
}

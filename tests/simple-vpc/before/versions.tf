terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  # Used to aid in diffing across v6/v7 in separate folders
  backend "s3" {
    bucket = "terraform-aws-vpc-v7"
    key    = "simple-vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

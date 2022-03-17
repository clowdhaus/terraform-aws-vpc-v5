terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }

  # Used to aid in diffing across v3/v4 in separate folders
  backend "s3" {
    bucket = "terraform-aws-vpc-v4"
    key    = "complete-vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

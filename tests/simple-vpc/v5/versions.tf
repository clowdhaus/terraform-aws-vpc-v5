terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4"
    }
  }

  # Used to aid in diffing across v4/v5 in separate folders
  backend "s3" {
    bucket = "terraform-aws-vpc-v5"
    key    = "simple-vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

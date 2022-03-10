terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.3"
    }
  }

  # Used to aid in diffing across v3/v4 in separate folders
  backend "s3" {
    bucket = "terraform-aws-vpc-v4"
    key    = "simple-vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

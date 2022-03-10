provider "aws" {
  region = local.region
}

locals {
  name   = "simple-example"
  cidr   = "10.0.0.0/16"
  region = "eu-west-1"

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

# ################################################################################
# # VPC Module - Before
# ################################################################################

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "3.12.0"

#   name = local.name
#   cidr = local.cidr

#   azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

#   enable_ipv6 = true

#   enable_nat_gateway = false
#   single_nat_gateway = true

#   public_subnet_tags = {
#     Name = "overridden-name-public"
#   }

#   vpc_tags = {
#     Name = "vpc-name"
#   }

#   tags = local.tags
# }

################################################################################
# VPC Module - After
################################################################################

module "vpc" {
  source = "../../"

  name       = local.name
  cidr_block = local.cidr

  # Not in v3.x
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  vpc_tags = {
    Name = "vpc-name"
  }

  tags = local.tags
}

module "public_subnets" {
  source = "../../modules/subnets"

  name   = "${local.name}-public"
  vpc_id = module.vpc.id

  subnets = {
    "${local.region}a" = {
      cidr_block         = "10.0.1.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
    }
    "${local.region}b" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "${local.region}b"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
      routes = {
        igw = {
          destination_cidr_block = "0.0.0.0/0"
          gateway_id             = module.vpc.internet_gateway_id
        }
      }
    }
  }

  tags = local.tags
}


module "private_subnets" {
  source = "../../modules/subnets"

  name   = "${local.name}-private"
  vpc_id = module.vpc.id

  subnets = {
    "${local.region}a" = {
      cidr_block         = "10.0.1.0/24"
      availability_zone  = "${local.region}a"
      create_nat_gateway = true
    }
    "${local.region}b" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "${local.region}b"
    }
    "${local.region}c" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "${local.region}b"
    }
  }

  route_tables = {
    shared = {
      associated_subnet_keys = ["${local.region}a", "${local.region}b", "${local.region}c"]
      routes = {
        ngw = {
          destination_cidr_block = "0.0.0.0/0"
          nat_gateway_key        = "${local.region}a"
        }
      }
    }
  }

  tags = local.tags
}

# tf state mv 'module.vpc.aws_subnet.public[0]' 'module.public_subnets.aws_subnet.this["eu-west-1a"]'
# tf state mv 'module.vpc.aws_subnet.public[1]' 'module.public_subnets.aws_subnet.this["eu-west-1b"]'
# tf state mv 'module.vpc.aws_subnet.public[2]' 'module.public_subnets.aws_subnet.this["eu-west-1c"]'

# tf state mv 'module.vpc.aws_subnet.private[0]' 'module.private_subnets.aws_subnet.this["eu-west-1a"]'
# tf state mv 'module.vpc.aws_subnet.private[1]' 'module.private_subnets.aws_subnet.this["eu-west-1b"]'
# tf state mv 'module.vpc.aws_subnet.private[2]' 'module.private_subnets.aws_subnet.this["eu-west-1c"]'

# tf state mv 'module.vpc.aws_route_table.public[0]'  'module.public_subnets.aws_route_table.this["shared"]'
# tf state mv 'module.vpc.aws_route_table.private[0]' 'module.private_subnets.aws_route_table.this["shared"]'

# tf state mv 'module.vpc.aws_route_table_association.public[0]' 'module.public_subnets.aws_route_table_association.subnet["eu-west-1a"]'
# tf state mv 'module.vpc.aws_route_table_association.public[1]' 'module.public_subnets.aws_route_table_association.subnet["eu-west-1b"]'
# tf state mv 'module.vpc.aws_route_table_association.public[2]' 'module.public_subnets.aws_route_table_association.subnet["eu-west-1c"]'

# tf state mv 'module.vpc.aws_route_table_association.private[0]' 'module.private_subnets.aws_route_table_association.subnet["eu-west-1a"]'
# tf state mv 'module.vpc.aws_route_table_association.private[1]' 'module.private_subnets.aws_route_table_association.subnet["eu-west-1b"]'
# tf state mv 'module.vpc.aws_route_table_association.private[2]' 'module.private_subnets.aws_route_table_association.subnet["eu-west-1c"]'

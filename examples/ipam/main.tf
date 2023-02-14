provider "aws" {
  region = local.region1
}

provider "aws" {
  alias  = "useast1"
  region = local.region2
}

locals {
  name    = "vpc-ex-${basename(path.cwd)}"
  region1 = "eu-west-1"
  region2 = "us-west-2"

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc-v5"
  }
}

################################################################################
# IPAM Module
################################################################################

module "ipam" {
  source = "../../modules/ipam"

  description       = "Top level example"
  operating_regions = [local.region1, local.region2]

  # Top level pool
  pool_cidr                              = "10.0.0.0/8"
  pool_allocation_min_netmask_length     = 10
  pool_allocation_default_netmask_length = 10
  pool_allocation_max_netmask_length     = 16

  scopes = {
    one = {
      description = "Example scope one"
    }
    two = {
      description = "Example scope two"
    }
  }

  tags = local.tags
}

################################################################################
# IPAM Pool Module - Regional
################################################################################

module "ipam_regional_pool" {
  source = "../../modules/ipam-pool"

  for_each = {
    (local.region1) = {
      locale = local.region1
      cidr   = "10.0.0.0/10"
    },
    (local.region2) = {
      locale = local.region2
      cidr   = "10.64.0.0/10"
    }
  }

  locale = each.value.locale

  description         = "Regional example"
  ipam_scope_id       = module.ipam.private_default_scope_id
  source_ipam_pool_id = module.ipam.pool_id

  cidr                              = each.value.cidr
  allocation_min_netmask_length     = 12
  allocation_default_netmask_length = 12
  allocation_max_netmask_length     = 18

  tags = local.tags
}

################################################################################
# IPAM Pool Module - Workload
################################################################################

module "ipam_pool_nonprod" {
  source = "../../modules/ipam-pool"

  # Here we will confine nonproduction to one region
  for_each = {
    (local.region1) = {
      locale = local.region1
      cidr   = "10.0.0.0/12"
    },
  }

  locale = module.ipam_regional_pool[each.value.locale].locale

  description         = "Workload non-production example"
  ipam_scope_id       = module.ipam.private_default_scope_id
  source_ipam_pool_id = module.ipam_regional_pool[each.value.locale].id

  cidr                              = each.value.cidr
  allocation_min_netmask_length     = 18
  allocation_default_netmask_length = 18
  allocation_max_netmask_length     = 24

  tags = local.tags
}

module "ipam_pool_prod" {
  source = "../../modules/ipam-pool"

  for_each = {
    (local.region1) = {
      locale = local.region1
      cidr   = "10.16.0.0/12"
    },
    (local.region2) = {
      locale = local.region2
      cidr   = "10.64.0.0/12"
    },
  }

  locale = module.ipam_regional_pool[each.value.locale].locale

  description         = "Workload production example"
  ipam_scope_id       = module.ipam.private_default_scope_id
  source_ipam_pool_id = module.ipam_regional_pool[each.value.locale].id

  cidr                              = each.value.cidr
  allocation_min_netmask_length     = 16
  allocation_default_netmask_length = 16
  allocation_max_netmask_length     = 20

  tags = local.tags
}

################################################################################
# VPC Module
################################################################################

# Non-production
module "vpc_nonprod_euwest1" {
  source = "../../"

  name = "${local.name}-nonprod"

  # IPAM
  ipv4_ipam_pool_id = module.ipam_pool_nonprod[local.region1].id

  # Not required for this example
  create_internet_gateway       = false
  attach_internet_gateway       = false
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  tags = local.tags
}

# Production
module "vpc_prod_euwest1" {
  source = "../../"

  # Just for demo purposes
  count = 3

  name = "${local.name}-prod-${count.index}"

  # IPAM
  ipv4_ipam_pool_id = module.ipam_pool_prod[local.region1].id

  # Not required for this example
  create_internet_gateway       = false
  attach_internet_gateway       = false
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  tags = local.tags
}

module "vpc_prod_useast1" {
  source = "../../"
  providers = {
    aws = aws.useast1
  }

  name = "${local.name}-prod"

  # IPAM
  ipv4_ipam_pool_id = module.ipam_pool_prod[local.region2].id

  # Not required for this example
  create_internet_gateway       = false
  attach_internet_gateway       = false
  enable_dnssec_config          = false
  manage_default_security_group = false
  manage_default_network_acl    = false
  manage_default_route_table    = false

  tags = local.tags
}

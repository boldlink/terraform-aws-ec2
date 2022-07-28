module "ec2_vpc" {
  source                  = "boldlink/vpc/aws"
  version                 = "2.0.3"
  name                    = local.name
  account                 = local.account_id
  region                  = local.region
  cidr_block              = local.cidr_block
  enable_dns_hostnames    = true
  create_nat_gateway      = true
  nat_single_az           = true
  public_subnets          = local.public_subnets
  availability_zones      = local.azs
  map_public_ip_on_launch = true
  tags                    = local.tags
}

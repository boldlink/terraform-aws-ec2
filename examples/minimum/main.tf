##############################################################
# This example shows the minimum values to use this module
##############################################################

module "vpc" {
  source               = "git::https://github.com/boldlink/terraform-aws-vpc.git?ref=2.0.3"
  cidr_block           = local.cidr_block
  name                 = local.name
  enable_dns_support   = true
  enable_dns_hostnames = true
  account              = data.aws_caller_identity.current.account_id
  region               = data.aws_region.current.name

  ## public Subnets
  public_subnets          = local.public_subnets
  availability_zones      = local.azs
  map_public_ip_on_launch = true
  tag_env                 = local.tag_env
}

module "ec2_instance_minimum" {
  source            = "../../"
  name              = local.name
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "t2.small"
  vpc_id            = module.vpc.id
  monitoring        = true
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_id         = flatten(module.vpc.public_subnet_id)[0]
}

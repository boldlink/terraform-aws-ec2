######################################################################################################################################
### This example shows the complete values to use this module with t3 instances. Note: T3 instances have ebs optimization by default
######################################################################################################################################
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

module "ec2_instance_t3" {
  source                               = "../../"
  name                                 = local.name
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = "t3.large"
  vpc_id                               = module.vpc.id
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = flatten(module.vpc.public_subnet_id)[0]
  ebs_optimized                        = true
  associate_public_ip_address          = true
  environment                          = "development"
  monitoring                           = true
  source_dest_check                    = false
  enclave_options_enabled              = false
  tenancy                              = "default"
  cpu_credits                          = "unlimited"
  cpu_core_count                       = 1
  cpu_threads_per_core                 = 2
  instance_initiated_shutdown_behavior = "terminate"
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 15
  }
}

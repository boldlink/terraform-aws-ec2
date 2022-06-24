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

module "ec2_instance_windows" {
  source = "../../"
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  name                                 = local.name
  ami                                  = data.aws_ami.windows.id
  instance_type                        = "t2.medium"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = flatten(module.vpc.public_subnet_id)[0]
  associate_public_ip_address          = true
  vpc_id                               = module.vpc.id
  environment                          = "development"
  create_key_pair                      = true
  get_password_data                    = true
  tenancy                              = "default"
  instance_initiated_shutdown_behavior = "terminate"

  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
  }

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  root_block_device = [
    {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      iops                  = 300
      encrypted             = true
    }
  ]
}

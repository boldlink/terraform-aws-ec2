##############################################################
### This example shows the complete values to use this module
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

module "ec2_instance_complete" {
  source                      = "../../"
  name                        = local.name
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t2.medium"
  vpc_id                      = module.vpc.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  subnet_id                   = flatten(module.vpc.public_subnet_id)[0]
  create_ec2_kms_key          = true
  create_key_pair             = true
  associate_public_ip_address = true
  create_instance_iam_role    = true
  environment                 = "development"
  disable_api_termination     = false
  monitoring                  = true
  source_dest_check           = false
  enclave_options_enabled     = false
  private_ip                  = local.private_ip
  secondary_private_ips       = local.secondary_ips
  tenancy                     = "default"

  instance_initiated_shutdown_behavior = "terminate"

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  security_group_ingress = [
    {
      description = "inbound ssh traffic"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  root_block_device = [
    {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      iops                  = 300
    }
  ]

  ebs_block_device = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      volume_size           = 15
      volume_type           = "gp2"
      encrypted             = true
    }
  ]

  ephemeral_block_device = [
    {
      device_name  = "/dev/sdh"
      virtual_name = "ephemeral0"
    }
  ]

  timeouts = {
    create = "7m"
    update = "10m"
    delete = "15m"
  }
}

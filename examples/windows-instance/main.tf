module "ec2_instance_windows" {
  source                               = "../../"
  name                                 = var.name
  ami                                  = data.aws_ami.windows.id
  instance_type                        = var.instance_type
  create_ec2_kms_key                   = var.create_ec2_kms_key
  ebs_optimized                        = var.ebs_optimized
  vpc_id                               = local.vpc_id
  availability_zone                    = local.azs
  subnet_id                            = local.private_subnets
  tenancy                              = var.tenancy
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  monitoring                           = var.monitoring
  metadata_options                     = var.metadata_options
  install_ssm_agent                    = var.install_ssm_agent
  security_group_ingress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [local.vpc_cidr]
    }    
  ]
  security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = var.capacity_reservation_preference
  }
  root_block_device = var.root_block_device
  tags              = merge({ Name = var.name }, var.tags)
}

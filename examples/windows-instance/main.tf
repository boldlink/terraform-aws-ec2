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
  create_key_pair                      = var.create_key_pair
  get_password_data                    = var.get_password_data
  tenancy                              = var.tenancy
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  monitoring                           = var.monitoring
  metadata_options                     = var.metadata_options
  capacity_reservation_specification = {
    capacity_reservation_preference = var.capacity_reservation_preference
  }
  root_block_device = var.root_block_device
  tags              = merge({ Name = var.name }, var.tags)
}

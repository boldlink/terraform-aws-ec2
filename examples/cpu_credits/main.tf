######################################################################################################################################
### This example shows the complete values to use this module with t3 instances. Note: T3 instances have ebs optimization by default
######################################################################################################################################
module "ec2_instance_t3" {
  source                               = "../../"
  name                                 = var.name
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = var.instance_type
  vpc_id                               = local.vpc_id
  availability_zone                    = local.azs
  subnet_id                            = local.private_subnets
  ebs_optimized                        = var.ebs_optimized
  create_ec2_kms_key                   = var.create_ec2_kms_key
  monitoring                           = var.monitoring
  source_dest_check                    = var.source_dest_check
  tenancy                              = var.tenancy
  cpu_credits                          = var.cpu_credits
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  metadata_options                     = var.metadata_options
  root_block_device                    = var.root_block_device
  tags                                 = merge({ Name = var.name }, var.tags)

  cpu_options = {
    core_count       = var.cpu_core_count
    threads_per_core = var.cpu_threads_per_core
  }
}

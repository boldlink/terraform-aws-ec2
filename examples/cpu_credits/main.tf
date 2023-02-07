######################################################################################################################################
### This example shows the complete values to use this module with t3 instances. Note: T3 instances have ebs optimization by default
######################################################################################################################################
module "ec2_instance_t3" {
  source                               = "../../"
  name                                 = local.name
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = "t3.large"
  vpc_id                               = local.vpc_id
  availability_zone                    = local.azs
  subnet_id                            = local.public_subnets
  ebs_optimized                        = true
  create_ec2_kms_key                   = true
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

  root_block_device = [
    {
      volume_size           = 15
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      iops                  = 300
    }
  ]
  tags = local.tags
}

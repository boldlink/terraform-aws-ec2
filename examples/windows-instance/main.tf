module "ec2_instance_windows" {
  source = "../../"
  name                                 = local.name
  ami                                  = data.aws_ami.windows.id
  instance_type                        = "t3.medium"
  create_ec2_kms_key                   = true
  ebs_optimized                        = true
  vpc_id                               = local.vpc_id
  availability_zone                    = local.azs
  subnet_id                            = local.public_subnets
  create_key_pair                      = true
  get_password_data                    = true
  tenancy                              = "default"
  instance_initiated_shutdown_behavior = "terminate"
  monitoring                           = true

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

  tags = local.tags
}

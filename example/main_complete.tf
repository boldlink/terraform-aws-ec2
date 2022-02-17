# #############################################################
# This example shows the complete values to use this module
# #############################################################

module "ec2_instance_complete" {
  source = "./.."

  depends_on = [
    module.ec2_instance_minimum,
    module.ec2_instance_t3,
    module.ec2_instance_windows
  ]

  name                                 = "${local.name}-complete"
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = "m5.large"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = data.aws_subnet.default.id
  vpc_security_group_ids               = [data.aws_security_group.default.id]
  ebs_optimized                        = true
  user_data                            = base64encode(local.user_data)
  associate_public_ip_address          = true
  environment                          = "development"
  disable_api_termination              = false
  monitoring                           = true
  source_dest_check                    = false
  enclave_options_enabled              = false
  private_ip                           = local.private_ip
  secondary_private_ips                = local.secondary_ips
  tenancy                              = "default"
  cpu_core_count                       = 1
  cpu_threads_per_core                 = 2
  instance_initiated_shutdown_behavior = "terminate"
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 20
  }

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  root_block_device = [
    {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = data.aws_ebs_default_kms_key.current.key_arn
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
      kms_key_id            = data.aws_ebs_default_kms_key.current.key_arn
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

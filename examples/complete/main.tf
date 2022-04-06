# #############################################################
# This example shows the complete values to use this module
# #############################################################

module "ec2_instance_complete" {
  source                               = "./../.."
  name                                 = "${local.name}-complete"
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = "m5.large"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = data.aws_subnet.default.id
  ebs_optimized                        = true
  create_ec2_kms_key                   = true
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

module "ec2_instance_windows" {
  source                               = "./../.."
  name                                 = "${local.name}-windows"
  ami                                  = data.aws_ami.windows.id
  instance_type                        = "m5.large"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = data.aws_subnet.default.id
  ebs_optimized                        = true
  associate_public_ip_address          = true
  environment                          = "development"
  create_key_pair                      = true
  get_password_data                    = true
  tenancy                              = "default"
  cpu_core_count                       = 1
  cpu_threads_per_core                 = 2
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

output "outputs" {
  value = [
    module.ec2_instance_windows
  ]
}

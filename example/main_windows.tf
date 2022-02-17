module "tls_private_key" {
  source = "./../../../../tls/private_key/"
}

module "key_pair" {
  source = "./../../../key_pair/"

  key_name   = "EC2-keypair-${uuid()}" #Create/Publish keypair to AWS
  public_key = module.tls_private_key.public_key_openssh
}

resource "null_resource" "local_save_ec2_keypair" {
  provisioner "local-exec" {
    command = "echo '${module.tls_private_key.private_key_pem}' > ${path.module}/${module.key_pair.id}.pem"
  }
}

module "ec2_instance_windows" {
  source = "./.."

  depends_on                           = [module.tls_private_key]
  name                                 = "${local.name}-windows"
  ami                                  = data.aws_ami.windows.id
  instance_type                        = "m5.large"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = data.aws_subnet.default.id
  vpc_security_group_ids               = [data.aws_security_group.default.id]
  ebs_optimized                        = true
  key_name                             = module.key_pair.name
  associate_public_ip_address          = true
  environment                          = "development"
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
      kms_key_id            = data.aws_ebs_default_kms_key.current.key_arn
    }
  ]

}

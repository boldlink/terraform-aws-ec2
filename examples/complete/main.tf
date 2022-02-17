# #############################################################
# This example shows the complete values to use this module
# #############################################################
resource "tls_private_key" "main" {
  algorithm   = "RSA"
  ecdsa_curve = "P224"
  rsa_bits    = 4096
}

resource "aws_key_pair" "main" {
  key_name   = "EC2-keypair-${uuid()}" #Create/Publish keypair to AWS
  public_key = tls_private_key.main.public_key_openssh
}

resource "null_resource" "local_save_ec2_keypair" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.main.private_key_pem}' > ${path.module}/${aws_key_pair.main.id}.pem"
  }
}

module "ec2_instance_complete" {
  source                               = "./../.."
  name                                 = "${local.name}-complete"
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = "m5.large"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = data.aws_subnet.default.id
  vpc_security_group_ids               = [data.aws_security_group.default.id]
  ebs_optimized                        = true
  key_name                             = aws_key_pair.main.key_name
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

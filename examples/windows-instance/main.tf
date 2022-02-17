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

module "ec2_instance_windows" {
  source                               = "./../.."
  name                                 = "${local.name}-windows"
  ami                                  = data.aws_ami.windows.id
  instance_type                        = "m5.large"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = data.aws_subnet.default.id
  vpc_security_group_ids               = [data.aws_security_group.default.id]
  ebs_optimized                        = true
  key_name                             = aws_key_pair.main.key_name
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

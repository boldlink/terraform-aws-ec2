# #################################################################################################################################
# This example shows the complete values to use this module with t3 instances. Note: T3 instances have ebs optimization by default
# #################################################################################################################################
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

module "ec2_instance_t3" {
  source                               = "boldlink/ec2/aws"
  version                              = "1.0.1"
  name                                 = "${local.name}-t3"
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = "t3.large"
  availability_zone                    = data.aws_availability_zones.available.names[0]
  subnet_id                            = data.aws_subnet.default.id
  vpc_security_group_ids               = [data.aws_security_group.default.id]
  ebs_optimized                        = true
  user_data                            = base64encode(local.user_data)
  associate_public_ip_address          = true
  environment                          = "development"
  key_name                             = aws_key_pair.main.key_name
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

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  root_block_device = [
    {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      iops                  = 300
    }
  ]

  ebs_block_device = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      volume_size           = 15
      volume_type           = "gp2"
    }
  ]
}

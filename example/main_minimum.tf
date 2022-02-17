
# #############################################################
# This example shows the minimum values to use this module
# #############################################################
module "ec2_instance_minimum" {
  source = "./.."

  name                        = "${local.name}-minimum"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "m5.large"
  availability_zone           = data.aws_availability_zones.available.names[0]
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  ebs_optimized               = true
  user_data                   = base64encode(local.user_data)
  associate_public_ip_address = true
  environment                 = "development"
  root_block_device = [
    {
      delete_on_termination = true
      volume_size           = 15
      volume_type           = "gp2"
      encrypted             = true
      kms_key_id            = data.aws_ebs_default_kms_key.current.key_arn
    }
  ]
}

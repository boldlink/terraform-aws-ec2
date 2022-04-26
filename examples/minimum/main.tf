
# #############################################################
# This example shows the minimum values to use this module
# #############################################################
module "ec2_instance_minimum" {
  source                      = "boldlink/ec2/aws"
  name                        = "${local.name}-minimum"
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "m5.large"
  availability_zone           = data.aws_availability_zones.available.names[0]
  subnet_id                   = data.aws_subnet.default.id
  ebs_optimized               = true
  associate_public_ip_address = true
  environment                 = "development"
  root_block_device = [
    {
      delete_on_termination = true
      volume_size           = 15
      volume_type           = "gp2"
    }
  ]
}

output "outputs" {
  value = [
    module.ec2_instance_minimum
  ]
}

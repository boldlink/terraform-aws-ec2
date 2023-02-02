##############################################################
# This example shows the minimum values to use this module
##############################################################
module "ec2_instance_minimum" {
  source            = "../../"
  name              = local.name
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "t3.small"
  monitoring        = true
  ebs_optimized     = true
  vpc_id            = local.vpc_id
  availability_zone = local.azs
  subnet_id         = local.public_subnets
  tags              = local.tags
}

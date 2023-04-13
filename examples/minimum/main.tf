##############################################################
# This example shows the minimum values to use this module
##############################################################
module "ec2_instance_minimum" {
  source            = "../../"
  name              = var.name
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = var.instance_type
  monitoring        = var.monitoring
  ebs_optimized     = var.ebs_optimized
  vpc_id            = local.vpc_id
  availability_zone = local.azs
  subnet_id         = local.private_subnets
  tags              = merge({ Name = var.name }, var.tags)
  root_block_device = var.root_block_device
}

##############################################################
# This example shows the minimum values to use this module
##############################################################
module "ec2_instance_minimum" {
  source = "../../"
  #checkov:skip=CKV_AWS_126:Ensure that detailed monitoring is enabled for EC2 instances
  name              = local.name
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "t2.small"
  monitoring        = true
  vpc_id            = local.vpc_id
  availability_zone = local.azs[0]
  subnet_id         = local.public_subnets[0]
  other_tags        = local.tags
}

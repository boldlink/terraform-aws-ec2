##############################################################
# This example shows the minimum values to use this module
##############################################################
module "ec2_instance_minimum" {
  source            = "../../"
  name              = "minimum-example"
  ami               = data.aws_ami.amazon_linux.id
  instance_type     = "t2.small"
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_id         = data.aws_subnet.default.id
}

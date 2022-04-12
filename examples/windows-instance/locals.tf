locals {
  name          = "ec2-module-${uuid()}"
  private_ip    = cidrhost(data.aws_subnet.default.cidr_block, 100)
  address1      = cidrhost(data.aws_subnet.default.cidr_block, 200)
  address2      = cidrhost(data.aws_subnet.default.cidr_block, 211)
  address3      = cidrhost(data.aws_subnet.default.cidr_block, 220)
  secondary_ips = [local.address1, local.address2, local.address3]
}

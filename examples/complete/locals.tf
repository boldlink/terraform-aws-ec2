locals {
  subnet_cidr = [
    for s in data.aws_subnet.private : s.cidr_block
  ]

  subnet_az = [
    for az in data.aws_subnet.private : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.private : i.id
  ]

  private_subnets = local.subnet_id[0]
  azs             = local.subnet_az[0]
  private_ip      = cidrhost(flatten(local.subnet_cidr)[0], 15)
  address1        = cidrhost(flatten(local.subnet_cidr)[0], 5)
  address2        = cidrhost(flatten(local.subnet_cidr)[0], 7)
  address3        = cidrhost(flatten(local.subnet_cidr)[0], 10)
  secondary_ips   = [local.address1, local.address2, local.address3]
  vpc_id          = data.aws_vpc.supporting.id
}

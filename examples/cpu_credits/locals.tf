locals {
  subnet_az = [
    for az in data.aws_subnet.private : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.private : i.id
  ]

  private_subnets = local.subnet_id[1]
  azs             = local.subnet_az[1]
  vpc_id          = data.aws_vpc.supporting.id
}

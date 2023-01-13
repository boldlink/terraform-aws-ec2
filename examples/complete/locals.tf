locals {
  subnet_cidr = [
    for s in data.aws_subnet.public : s.cidr_block
  ]

  subnet_az = [
    for az in data.aws_subnet.public : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]

  name                      = "complete-ec2-example"
  public_subnets            = local.subnet_id[0]
  azs                       = local.subnet_az[0]
  private_ip                = cidrhost(flatten(local.subnet_cidr)[0], 15)
  address1                  = cidrhost(flatten(local.subnet_cidr)[0], 5)
  address2                  = cidrhost(flatten(local.subnet_cidr)[0], 7)
  address3                  = cidrhost(flatten(local.subnet_cidr)[0], 10)
  secondary_ips             = [local.address1, local.address2, local.address3]
  supporting_resources_name = "terraform-aws-ec2"
  vpc_id                    = data.aws_vpc.supporting.id
  vpc_cidr                  = data.aws_vpc.supporting.cidr_block
  tags = {
    Environment        = "example"
    Name               = local.name
    "user::CostCenter" = "terraform-registry"
    InstanceScheduler  = true
    Department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "cExample"
    LayerId            = "c300"
  }
}

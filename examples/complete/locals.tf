locals {
  subnet_cidr = [
    for s in data.aws_subnet.public : s.cidr_block
  ]
  name                      = "complete-ec2-example"
  public_subnets            = flatten(data.aws_subnets.public.ids)
  azs                       = flatten(data.aws_availability_zones.available.names)
  private_ip                = cidrhost(flatten(local.subnet_cidr)[0], 15)
  address1                  = cidrhost(flatten(local.subnet_cidr)[0], 5)
  address2                  = cidrhost(flatten(local.subnet_cidr)[0], 7)
  address3                  = cidrhost(flatten(local.subnet_cidr)[0], 10)
  secondary_ips             = [local.address1, local.address2, local.address3]
  supporting_resources_name = "terraform-aws-ec2"
  vpc_id                    = data.aws_vpc.supporting.id
  tags = {
    environment        = "examples"
    name               = local.name
    "user::CostCenter" = "terraform-registry"
  }
}

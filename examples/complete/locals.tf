locals {
  name           = "complete-ec2-example"
  cidr_block     = "172.16.0.0/16"
  tag_env        = "Dev"
  public_subnets = cidrsubnets(local.cidr_block, 8, 8, 8)
  azs            = flatten(data.aws_availability_zones.available.names)
  private_ip     = cidrhost(flatten(local.public_subnets)[0], 100)
  address1       = cidrhost(flatten(local.public_subnets)[0], 200)
  address2       = cidrhost(flatten(local.public_subnets)[0], 211)
  address3       = cidrhost(flatten(local.public_subnets)[0], 220)
  secondary_ips  = [local.address1, local.address2, local.address3]
}

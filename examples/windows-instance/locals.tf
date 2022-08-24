locals {
  subnet_az = [
    for az in data.aws_subnet.public : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]

  name                      = "windows-ec2-example"
  public_subnets            = local.subnet_id[0]
  azs                       = local.subnet_az[0]
  supporting_resources_name = "terraform-aws-ec2"
  vpc_id                    = data.aws_vpc.supporting.id
  tags = {
    Environment        = "examples"
    Name               = local.name
    "user::CostCenter" = "terraform-registry"
  }
}

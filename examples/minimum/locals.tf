locals {
  subnet_az = [
    for az in data.aws_subnet.public : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]

  name                      = "minimum-ec2-example"
  public_subnets            = local.subnet_id[2]
  azs                       = local.subnet_az[2]
  supporting_resources_name = "terraform-aws-ec2"
  vpc_id                    = data.aws_vpc.supporting.id
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

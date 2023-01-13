locals {
  subnet_az = [
    for az in data.aws_subnet.public : az.availability_zone
  ]

  subnet_id = [
    for i in data.aws_subnet.public : i.id
  ]

  name                      = "cpu_credits-ec2-example"
  public_subnets            = local.subnet_id[1]
  azs                       = local.subnet_az[1]
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
    LayerId            = "cExample"
  }
}

locals {
  name                      = "minimum-ec2-example"
  public_subnets            = flatten(data.aws_subnets.public.ids)
  azs                       = flatten(data.aws_availability_zones.available.names)
  supporting_resources_name = "terraform-aws-ec2"
  vpc_id                    = data.aws_vpc.supporting.id
  tags = {
    environment        = "examples"
    name               = local.name
    "user::CostCenter" = "terraform-registry"
  }
}

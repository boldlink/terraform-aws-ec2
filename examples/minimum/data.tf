data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-*-x86_64-gp2"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["${local.supporting_resources_name}*.pub.*"]
  }
}

data "aws_vpc" "supporting" {
  filter {
    name   = "tag:Name"
    values = [local.supporting_resources_name]
  }
}

##############################################################
### This example shows the complete values to use this module
##############################################################
module "ec2_instance_complete" {
  #checkov:skip=CKV_AWS_290: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_355: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  source                               = "../../"
  name                                 = var.name
  ami                                  = data.aws_ami.amazon_linux.id
  instance_type                        = var.instance_type
  vpc_id                               = local.vpc_id
  availability_zone                    = local.azs
  subnet_id                            = local.private_subnets
  create_ec2_kms_key                   = var.create_ec2_kms_key
  ebs_optimized                        = var.ebs_optimized
  create_instance_iam_role             = var.create_instance_iam_role
  monitoring                           = var.monitoring
  source_dest_check                    = var.source_dest_check
  private_ip                           = local.private_ip
  secondary_private_ips                = local.secondary_ips
  tenancy                              = var.tenancy
  root_block_device                    = var.root_block_device
  ebs_block_device                     = var.ebs_block_device
  ephemeral_block_device               = var.ephemeral_block_device
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  capacity_reservation_specification = {
    capacity_reservation_preference = var.capacity_reservation_preference
  }
  timeouts = var.timeouts
  tags     = merge({ Name = var.name }, var.tags)

  security_group_ingress = [
    {
      description = "inbound ssh traffic"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [local.vpc_cidr]
    }
  ]
}

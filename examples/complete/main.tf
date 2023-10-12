##############################################################
### This example shows the complete values to use this module
##############################################################
module "ec2_instance_complete" {
  #checkov:skip=CKV_AWS_290: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_355: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
  source                               = "../../"
  name                                 = var.name
  ami                                  = data.aws_ami.ubuntu.id
  instance_type                        = var.instance_type
  vpc_id                               = local.vpc_id
  availability_zone                    = local.azs
  associate_public_ip_address          = null
  create_ec2_kms_key                   = var.create_ec2_kms_key
  ebs_optimized                        = var.ebs_optimized
  create_instance_iam_role             = var.create_instance_iam_role
  monitoring                           = var.monitoring
  source_dest_check                    = var.source_dest_check
  tenancy                              = var.tenancy
  root_block_device                    = var.root_block_device
  ebs_block_device                     = var.ebs_block_device
  ephemeral_block_device               = var.ephemeral_block_device
  extra_script                         = templatefile("${path.module}/extra_script.sh", {})
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  capacity_reservation_specification = {
    capacity_reservation_preference = var.capacity_reservation_preference
  }
  network_interfaces = [
    {
      network_interface_id  = aws_network_interface.example.id
      delete_on_termination = false
    }
  ]
  timeouts = var.timeouts
  tags     = merge({ Name = var.name }, var.tags)
}

resource "aws_network_interface" "example" {
  subnet_id   = local.subnet_id[0]
  private_ips = local.private_ips
  tags        = merge({ Name = var.name }, var.tags)
}


## Creating an ec2 instance using a launch template
resource "aws_launch_template" "example" {
  name     = "${var.name}-lt"
  image_id = data.aws_ami.ubuntu.id
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 20
    }
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }
  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }
  tags = merge({ Name = "${var.name}-lt" }, var.tags)
}

module "launch_template_ec2" {
  #heckov:skip=CKV_AWS_8: "Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted"
  source            = "../../"
  name              = "${var.name}-lt"
  instance_type     = var.instance_type
  subnet_id         = local.private_subnets
  vpc_id            = local.vpc_id
  monitoring        = var.monitoring
  root_block_device = var.root_block_device
  launch_template = {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  tags = merge({ Name = "${var.name}-lt" }, var.tags)
}

##############################################################
### This example shows the complete values to use this module
##############################################################

resource "aws_placement_group" "example" {
  name     = "${var.name}-pg"
  strategy = "partition"
}

resource "aws_security_group" "network_interface" {
  name        = "${var.name}-sg"
  description = "${var.name} security group"
  vpc_id      = local.vpc_id

  egress {
    description      = "Allow egress traffic rule"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Example external policy to attach to the ec2 instance Role
module "ec2_policy" {
  source                 = "boldlink/iam-policy/aws"
  version                = "1.1.0"
  policy_name            = "${var.name}-policy"
  policy_attachment_name = "${var.name}-attachment"
  description            = "IAM policy to grant EC2 describe permissions"
  roles                  = [module.ec2_instance_complete.role_name]
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowGetEncryptionConfiguration"
        Action = ["s3:GetEncryptionConfiguration",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::example-bucket" #This is an example ARN
      }
    ]
  })
  tags = merge({ Name = "${var.name}-policy" }, var.tags)
}

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
  install_ssm_agent                    = var.install_ssm_agent
  extra_script                         = templatefile("${path.module}/extra_script.sh", {})
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  placement_group                      = aws_placement_group.example.id
  placement_partition_number           = 1
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
  subnet_id       = local.subnet_id[0]
  private_ips     = local.private_ips
  security_groups = [aws_security_group.network_interface.id]
  tags            = merge({ Name = var.name }, var.tags)
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

module "ec2_with_lt" {
  #checkov:skip=CKV_AWS_8: "Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted"
  source            = "../../"
  name              = "${var.name}-lt"
  instance_type     = var.instance_type
  subnet_id         = local.private_subnets
  vpc_id            = local.vpc_id
  monitoring        = var.monitoring
  root_block_device = var.root_block_device
  user_data_base64  = local.user_data_base64
  launch_template = {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  tags = merge({ Name = "${var.name}-lt" }, var.tags)
}

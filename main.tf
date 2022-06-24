### Userdata -> See Scripts and data.tf

##########################################################
### KMS use default or external or one created by module
##########################################################
resource "aws_kms_key" "main" {
  count                   = var.create_ec2_kms_key ? 1 : 0
  description             = "EC2 KMS key"
  enable_key_rotation     = var.enable_key_rotation
  deletion_window_in_days = var.key_deletion_window_in_days
}

###################################
### Log group (encrypted)
###################################
resource "aws_kms_key" "cloudwatch" {
  count                   = var.monitoring ? 1 : 0
  description             = "Log Group KMS key"
  enable_key_rotation     = var.enable_key_rotation
  policy                  = element(concat(data.aws_iam_policy_document.main.*.json, [""]), 0)
  deletion_window_in_days = var.key_deletion_window_in_days
}

resource "aws_cloudwatch_log_group" "main" {
  count             = var.monitoring ? 1 : 0
  name              = "/aws/ec2/${var.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = aws_kms_key.cloudwatch[0].arn
  tags = merge(
    {
      "Name"        = var.name
      "Environment" = var.environment
    },
    var.other_tags,
  )
}

###################################
### Security Group
###################################
resource "aws_security_group" "main" {
  name        = "${var.name}-security-group"
  description = "Control traffic to the EC2 instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      description      = "Rule to allow port ${try(ingress.value.from_port, "")} inbound traffic"
      from_port        = lookup(ingress.value, "from_port", 0)
      to_port          = lookup(ingress.value, "to_port", 0)
      protocol         = lookup(ingress.value, "protocol", "-1")
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", ["0.0.0.0/0"])
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", ["::/0"])
    }
  }

  egress {
    description      = "Rule to allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

##################################################
### Key pair (as optional)
##################################################
resource "tls_private_key" "main" {
  count     = var.create_key_pair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "main" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = "${var.name}-keypair"
  public_key = tls_private_key.main[0].public_key_openssh
}

## For downloading the keypair to local computer
resource "null_resource" "local_save_ec2_keypair" {
  count = var.create_key_pair ? 1 : 0
  provisioner "local-exec" {
    command = "echo '${tls_private_key.main[0].private_key_pem}' > ${path.module}/${aws_key_pair.main[0].id}.pem"
  }
}

##################################################
### IAM Profile
##################################################
resource "aws_iam_instance_profile" "main" {
  count = var.create_instance_iam_role ? 1 : 0
  name  = "${var.name}_iam_role"
  path  = var.iam_role_path
  role  = join("", aws_iam_role.main.*.name)
}

resource "aws_iam_role" "main" {
  count              = var.create_instance_iam_role ? 1 : 0
  description        = "${var.name} EC2 IAM Role"
  name               = "${var.name}.iam_role"
  path               = var.iam_role_path
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "main" {
  count       = var.create_instance_iam_role && var.ec2_role_policy != null ? 1 : 0
  name        = "${var.name}-ec2-policy"
  description = "${var.name} EC2 IAM policy"
  path        = var.iam_role_path
  policy      = var.ec2_role_policy
}

resource "aws_iam_role_policy_attachment" "main" {
  count      = var.create_instance_iam_role && var.ec2_role_policy != null ? 1 : 0
  role       = join("", aws_iam_role.main.*.name)
  policy_arn = aws_iam_policy.main[0].arn
}

## Managed Policy to allow cloudwatch agent to write metrics to CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatchagentserverpolicy" {
  count      = var.create_instance_iam_role && var.monitoring ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = join("", aws_iam_role.main.*.name)
}

## Configure CloudWatch agent to set the retention policy for log groups that it sends log events to.
resource "aws_iam_role_policy" "logs_policy" {
  count = var.create_instance_iam_role && var.monitoring ? 1 : 0
  name  = "CloudWatchAgentPutLogsRetention"
  role  = join("", aws_iam_role.main.*.name)

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutRetentionPolicy",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

###################################################
### EC2 Instance
###################################################
resource "aws_instance" "main" {
  ami                                  = var.ami
  instance_type                        = var.instance_type
  iam_instance_profile                 = var.create_instance_iam_role ? aws_iam_instance_profile.main[0].name : var.iam_instance_profile
  availability_zone                    = var.availability_zone
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  key_name                             = var.create_key_pair ? aws_key_pair.main[0].key_name : var.key_name
  monitoring                           = var.monitoring
  vpc_security_group_ids               = [aws_security_group.main.id]
  source_dest_check                    = var.source_dest_check
  user_data                            = var.monitoring ? base64encode(data.template_cloudinit_config.config.rendered) : var.user_data
  user_data_base64                     = var.user_data_base64
  subnet_id                            = var.subnet_id
  associate_public_ip_address          = var.associate_public_ip_address
  placement_group                      = var.placement_group
  placement_partition_number           = var.placement_partition_number
  private_ip                           = var.private_ip
  secondary_private_ips                = var.secondary_private_ips
  tenancy                              = var.tenancy
  cpu_core_count                       = var.cpu_core_count
  cpu_threads_per_core                 = var.cpu_threads_per_core
  get_password_data                    = var.create_key_pair ? var.get_password_data : null
  hibernation                          = var.hibernation
  host_id                              = var.host_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  ipv6_address_count                   = var.ipv6_address_count
  ipv6_addresses                       = var.ipv6_addresses
  enclave_options {
    enabled = var.enclave_options_enabled
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  dynamic "capacity_reservation_specification" {
    for_each = var.capacity_reservation_specification != null ? [var.capacity_reservation_specification] : []
    content {
      capacity_reservation_preference = lookup(capacity_reservation_specification.value, "capacity_reservation_preference", null)
      dynamic "capacity_reservation_target" {
        for_each = lookup(capacity_reservation_specification.value, "capacity_reservation_target", [])
        content {
          capacity_reservation_id = lookup(capacity_reservation_target.value, "capacity_reservation_id", null)
        }
      }
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = var.create_ec2_kms_key && lookup(root_block_device.value, "encrypted", null) == true ? aws_kms_key.main[0].arn : (var.use_ebs_default_kms && lookup(root_block_device.value, "encrypted", null) == true ? "alias/aws/ebs" : lookup(root_block_device.value, "kms_key_id", null))
      throughput            = lookup(root_block_device.value, "throughput", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = var.create_ec2_kms_key && lookup(ebs_block_device.value, "encrypted", null) == true ? aws_kms_key.main[0].arn : (var.use_ebs_default_kms && lookup(ebs_block_device.value, "encrypted", null) == true ? "alias/aws/ebs" : lookup(ebs_block_device.value, "kms_key_id", null))
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      throughput            = lookup(ebs_block_device.value, "throughput", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "launch_template" {
    for_each = var.launch_template != null ? [var.launch_template] : []
    content {
      id      = lookup(var.launch_template, "id", null)
      name    = lookup(var.launch_template, "name", null)
      version = lookup(var.launch_template, "version", null)
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  metadata_options {
    http_endpoint               = lookup(var.metadata_options, "http_endpoint", "enabled")
    http_put_response_hop_limit = lookup(var.metadata_options, "http_put_response_hop_limit", 1)
    http_tokens                 = lookup(var.metadata_options, "http_tokens", "optional")
  }

  dynamic "network_interface" {
    for_each = var.network_interface
    content {
      delete_on_termination = lookup(network_interface.value, "delete_on_termination", null)
      device_index          = network_interface.value.device_index
      network_interface_id  = lookup(network_interface.value, "network_interface_id", null)
    }
  }

  volume_tags = merge(
    {
      "Name"        = var.name
      "Environment" = var.environment
    },
    var.other_tags,
  )

  tags = merge(
    {
      "Name"        = var.name
      "Environment" = var.environment
    },
    var.other_tags,
  )

  lifecycle {
    ignore_changes = [
      tags,
      root_block_device,
      ebs_block_device
    ]
  }
}

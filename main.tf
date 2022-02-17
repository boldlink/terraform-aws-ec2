resource "aws_instance" "main" {
  ami                                  = var.ami
  instance_type                        = var.instance_type
  iam_instance_profile                 = var.iam_instance_profile
  availability_zone                    = var.availability_zone
  ebs_optimized                        = var.ebs_optimized
  disable_api_termination              = var.disable_api_termination
  key_name                             = var.key_name
  monitoring                           = var.monitoring
  vpc_security_group_ids               = var.vpc_security_group_ids
  source_dest_check                    = var.source_dest_check
  user_data                            = var.user_data
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
  get_password_data                    = var.get_password_data
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
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
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
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
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
}

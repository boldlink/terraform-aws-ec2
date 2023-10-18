variable "name" {
  description = "The name of the stack"
  type        = string
  default     = "complete-ec2-example"
}

variable "supporting_resources_name" {
  description = "Name of supporting resource VPC"
  type        = string
  default     = "terraform-aws-ec2"
}

variable "instance_type" {
  description = "The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance"
  type        = string
  default     = "t3.medium"
}

variable "architecture" {
  type        = string
  description = "The architecture of the instance to launch"
  default     = "amd64"
}

variable "create_ec2_kms_key" {
  description = "Choose whether to create kms key for ebs encryption"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = true
}

variable "create_instance_iam_role" {
  description = "Choose whether to create iam instance role"
  type        = bool
  default     = true
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled which pulls every 1m and adds additonal cost, default monitoring doesn't add costs"
  type        = bool
  default     = true
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = false
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = "default"
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance"
  type        = string
  default     = "terminate"
}

variable "capacity_reservation_preference" {
  description = "Indicates the instance's Capacity Reservation preferences. Can be 'open' or 'none'. (Default: 'open')"
  type        = string
  default     = "open"
}

variable "root_block_device" {
  description = "Configuration block to customize details about the root block device of the instance."
  type        = list(any)
  default = [
    {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
      iops                  = 300
    }
  ]
}

variable "ebs_block_device" {
  description = "One or more configuration blocks with additional EBS block devices to attach to the instance. Block device configurations only apply on resource creation."
  type        = list(any)
  default = [
    {
      delete_on_termination = true
      device_name           = "/dev/sdg"
      volume_size           = 15
      volume_type           = "gp2"
      encrypted             = true
    }
  ]
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default = [
    {
      device_name  = "/dev/sdh"
      virtual_name = "ephemeral0"
    }
  ]
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  type        = map(string)
  default = {
    create = "7m"
    update = "10m"
    delete = "15m"
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. Note that these tags apply to the instance and not block storage devices."
  type        = map(string)
  default = {
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    InstanceScheduler  = true
    Department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "Example"
    LayerId            = "Example"
  }
}

variable "install_ssm_agent" {
  type        = bool
  description = "Whether to install ssm agent"
  default     = true
}

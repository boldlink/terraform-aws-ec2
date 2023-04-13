variable "name" {
  description = "The name of the stack"
  type        = string
  default     = "windows-ec2-example"
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

variable "create_ec2_kms_key" {
  description = "Choose whether to create kms key for ebs encryption"
  type        = bool
  default     = true
}

variable "create_key_pair" {
  description = "Choose whether to create key pair"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = true
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it.  Useful for getting the administrator password for instances running Microsoft Windows."
  type        = bool
  default     = true
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

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled which pulls every 1m and adds additonal cost, default monitoring doesn't add costs"
  type        = bool
  default     = true
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 8
  }
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

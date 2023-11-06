variable "name" {
  description = "The name of the stack"
  type        = string
  default     = "cpu-credits-ec2-example"
}

variable "supporting_resources_name" {
  description = "Name of supporting resource VPC"
  type        = string
  default     = "terraform-aws-ec2"
}

variable "instance_type" {
  description = "The instance type to use for the instance. Updates to this field will trigger a stop/start of the EC2 instance"
  type        = string
  default     = "t3.large"
}

variable "architecture" {
  type        = string
  description = "The architecture of the instance to launch"
  default     = "x86_64"
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

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = "unlimited"
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance." # This option is only supported on creation of instance type that support CPU Options https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values
  type        = number
  default     = 1
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set)."
  type        = number
  default     = 2
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 15
  }
}

variable "root_block_device" {
  description = "Configuration block to customize details about the root block device of the instance."
  type        = list(any)
  default = [
    {
      volume_size           = 15
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

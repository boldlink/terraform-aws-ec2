variable "cidr_block" {
  type        = string
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length`."
  default     = "10.1.0.0/16"
}

variable "name" {
  type        = string
  description = "Input the name of stack"
  default     = "terraform-aws-ec2"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "(Optional) A boolean flag to enable/disable DNS hostnames in the VPC. Defaults `false`."
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "Whether to enable dns support for the vpc"
  default     = true
}

variable "enable_public_subnets" {
  type        = bool
  description = "Whether to enable public subnets"
  default     = true
}

variable "enable_private_subnets" {
  type        = bool
  description = "Whether to enable private subnets"
  default     = true
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is `false`."
  default     = true
}

variable "nat" {
  type        = string
  description = "Choose `single` or `multi` for NATs"
  default     = "single"
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default = {
    Environment        = "example"
    "user::CostCenter" = "terraform-registry"
    Department         = "DevOps"
    Project            = "Examples"
    Owner              = "Boldlink"
    LayerName          = "Example"
    LayerId            = "Example"
  }
}

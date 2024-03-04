variable "add_access_ip" {
  default     = false
  type        = bool
  description = "If you want to add a personal IP for SSH access. "
}

variable "access_ip" {
  default     = null
  description = "Should be formatted like '75.177.160.130/32' if your own IP"
  type        = list(string)
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "az_exclude_names" {
  type        = list(string)
  default     = ["us-east-1e"]
  description = "Exclude AZs if they don't have required services available. Potentially useful if an AZ isn't compatible with certain tiers of EC2 Instances or other issues"
}

variable "create_db_subnet_group" {
  default     = false
  type        = bool
  description = "set to True for RDS subnet groups"
}


variable "database_cidr" {
  type        = list(string)
  default     = ["10.10.10.0/25", "10.10.11.0/25"]
  description = "Examples using default VPC CIDR: '10.10.3.0/25'. Can use these in a list of strings depending on how you decide to iterate over them."
}

variable "environment" {
  default = "dev"
  type    = string
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_network_address_usage_metrics" {
  type    = bool
  default = false
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "public_cidr" {
  type        = list(string)
  default     = ["10.10.1.0/25", "10.10.3.0/25"]
  description = "Examples using default VPC CIDR: '10.10.1.0/25'. Can use these in a list of strings depending on how you decide to iterate over them."
}

variable "private_cidr" {
  type        = list(string)
  default     = ["10.10.2.0/25", "10.10.4.0/25"]
  description = "Examples using default VPC CIDR: '10.10.2.0/25'. Can use these in a list of strings depending on how you decide to iterate over them."

}

variable "public_subnet_ip_on_launch" {
  type    = bool
  default = true
}


variable "subnet_group_name" {
  default = "sngname"
  type    = string
}

variable "subnet_group_tag" {
  default = "tfsng"
  type    = string
}

variable "vpc_cidr" {
  default = "10.10.0.0/20"
}

variable "vpc_name" {
  type        = string
  description = "Descriptive VPC tag"
  default     = "TF_VPC"
}

variable "add_access_ip" {
  default     = false
  type        = bool
  description = "true - if you want to add a personal IP to the VPC security group for SSH access."
}

variable "access_ip" {
  default     = null
  description = "Takes a list of string if you have multiple IPs you want to add. Use a /32 CIDR with your IP. example: ['75.177.160.130/32']"
  type        = list(string)
}

variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "az_exclude_names" {
  type        = list(string)
  default     = ["us-east-1e"]
  description = "Exclude AZs if they don't have required services available. Potentially useful if an AZ isn't compatible with what you're doing."
}

variable "count_database_cidrs" {
  type        = list(string)
  default     = ["10.10.10.0/25", "10.10.11.0/25"]
  description = "Examples using default VPC CIDR: ['10.10.10.0/25', '10.10.11.0/25']"
}

variable "count_public_cidrs" {
  type        = list(string)
  default     = ["10.10.1.0/25", "10.10.3.0/25"]
  description = "Examples using default VPC CIDR: ['10.10.1.0/25', '10.10.3.0/25']"
}

variable "count_private_cidrs" {
  type        = list(string)
  default     = ["10.10.2.0/25", "10.10.4.0/25"]
  description = "Examples using default VPC CIDR: ['10.10.2.0/25'] "
}


variable "create_db_subnet_group" {
  default     = false
  type        = bool
  description = "set to True for RDS subnet groups"
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

variable "public_subnet_ip_on_launch" {
  type    = bool
  default = true
}

variable "subnet_group_name" {
  default = "tf-subnetgroup"
  type    = string
}

variable "subnet_group_tag" {
  default = "tf_subnetgroup"
  type    = string
}

variable "use_endpoints" {
  type = bool
  default = false
}

variable "use_nat_gateway" {
  default  = false
  type = bool
}

variable "vpc_cidr" {
  default = "10.10.0.0/20"
}

variable "vpc_name" {
  type        = string
  description = "Descriptive VPC tag"
  default     = "TF_VPC"
}
variable "vpc_endpoint" {
  default = null
  type = map(object({
      dns_record_ip_type=any
      ip_address_type=string
      private_dns_enabled=bool
      private_dns_only_for_inbound_resolver_endpoint=any
      route_table_ids=list(string)
      subnet_ids=list(string)
      security_group_ids=list(string)
      service_name=string
      vpc_endpoint_type=string
      vpc_id=string 
}))
}

variable "vpc_endpoint_policies"{
  default = null
}

locals {
  ep = {
    "s3endpoint"={
      dns_record_ip_type=null
      ip_address_type=null
      private_dns_enabled=false
      private_dns_only_for_inbound_resolver_endpoint=null
      route_table_ids=[aws_default_route_table.private_rt.id]
      subnet_ids=null
      security_group_ids=null
      service_name="com.amazonaws.us-east-1.s3"
      vpc_endpoint_type="Gateway"
      vpc_id=aws_vpc.this.id
    }

    "ecrapi"={
      dns_record_ip_type=null
      ip_address_type="ipv4"
      private_dns_enabled=true
      private_dns_only_for_inbound_resolver_endpoint=null
      route_table_ids=null
      subnet_ids=aws_subnet.private_subnet.*.id
      security_group_ids=[aws_security_group.default.id]
      service_name="com.amazonaws.us-east-1.ecr.api"
      vpc_endpoint_type="Interface"
      vpc_id=aws_vpc.this.id
    }

  }
  }

  # policies = {
  #   "s3endpoint" = {
  #     vpc_endpoint_id=aws_vpc_endpoint.this["s3endpoint"].id
  #     effect = "Allow"
  #     principal = "*"
  #     action = ["s3:*"]
  #     resource = "*"
  #   }
  # }
# }
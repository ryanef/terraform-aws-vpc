# AWS VPC TERRAFORM MODULE

This module is published on Terraform Registry and creates a VPC in us-east-1 by default. This can be changed with `aws_region` variable. By default it will create 2 subnets for three tiers: public, private, database.

SSH at port 22 is enabled in the security group but you will need to change `add_access_ip` variable to *true* and enter your IP address in the `access_ip` variable. As always, treat this as sensitive and manage it appropriately.

## NETWORKING DEFAULTS

For routing, there is a public route table that points to an Internet Gateway with a 0.0.0.0/0 CIDR block. The private route table is the VPC's default route table which is private by default.

## Changing Defaults

Most defaults can be changed in `variables.tf`

### VPC CIDR

The default VPC CIDR is 10.10.0.0/20 and can be changed at variable `"vpc_cidr"`

The default subnets are using /25 which give a total of 32 possible subnets.

### PUBLIC SUBNET DEFAULTS

Defaults: `[ "10.10.1.0/25", "10.10.3.0/25" ]`

variable `"public_cidr"`

variable `"public_subnet_count"`

### PRIVATE SUBNET DEFAULTS

Defaults: `[ "10.10.2.0/25", "10.10.4.0/25" ]`

variable `"private_cidr"`

variable `"private_subnet_count"`

### DATABASE SUBNET DEFAULTS

Defaults: `[ "10.10.10.0/25", "10.10.11.0/25" ]`

variable `"database_cidr"`

variable `"database_subnet_count"`

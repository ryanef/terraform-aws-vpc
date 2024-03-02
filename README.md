# AWS VPC TERRAFORM MODULE

This module is published on Terraform Registry and creates a VPC in us-east-1 by default. This can be changed with `aws_region` variable. By default it will create 2 subnets for three tiers: public, private, database.

SSH at port 22 is enabled in the security group but you will need to change `add_access_ip` variable to *true* and enter your IP address in the `access_ip` variable. As always, treat this as sensitive and manage it appropriately.

## NETWORKING DEFAULTS

For routing, there is a public route table that points to an `Internet Gateway` with a `0.0.0.0/0` CIDR block. The private route table is the VPC's default route table which is private by default.

## Changing Defaults

Most defaults can be changed in `variables.tf`

### VPC CIDR

The default VPC CIDR is `10.10.0.0/20` and can be changed at variable `"vpc_cidr"`

The default subnets are using `/25` which give a total of 32 possible subnets. A [subnet calculator](https://www.site24x7.com/tools/ipv4-subnetcalculator.html) can help if you're not familiar with subnetting but staying with `/25` here would be 32 subnets that have 128 host IPs per subnet:

```"10.10.0.0", "10.10.0.128", "10.10.1.0", "10.10.1.128", "10.10.2.0", "10.10.2.128", "10.10.3.0", "10.10.3.128", "10.10.4.0", "10.10.4.128", "10.10.5.0", "10.10.5.128", "10.10.6.0", "10.10.6.128", "10.10.7.0", "10.10.7.128", "10.10.8.0", "10.10.8.128", "10.10.9.0", "10.10.9.128", "10.10.10.0", "10.10.10.128", "10.10.11.0", "10.10.11.128", "10.10.12.0", "10.10.12.128", "10.10.13.0", "10.10.13.128", "10.10.14.0", "10.10.14.128", "10.10.15.0", "10.10.15.128"```

**Note about Reserved IP addresses in each subnet:**

- 10.10.0.**0** - the network address
- 10.10.0.**1** - Reserved by AWS - VPC Router
- 10.10.0.**2** - Reserved by AWS - DNS server
- 10.10.0.**3** - Reserved by AWS - future use / spare capacity
- 10.0.0.**255** - Network broadcast address although broadcast is not supported in AWS VPCs.

**Terraform determines how many subnets to create based on `length(public_cidr)`**

### PUBLIC SUBNET DEFAULTS

Defaults: `[ "10.10.1.0/25", "10.10.3.0/25" ]`

variable `"public_cidr"`

### PRIVATE SUBNET DEFAULTS

Defaults: `[ "10.10.2.0/25", "10.10.4.0/25" ]`

variable `"private_cidr"`

### DATABASE SUBNET DEFAULTS

Defaults: `[ "10.10.10.0/25", "10.10.11.0/25" ]`

variable `"database_cidr"`

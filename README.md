# AWS VPC TERRAFORM MODULE

This module is published on Terraform Registry and has default settings that create a VPC with 2 public subnets and 4 private subnets. NAT Gateway and VPC Endpoints are disabled by default but easily changed in `variables.tf`

See the [Application Loadbalancer](https://registry.terraform.io/modules/ryanef/loadbalancer/aws/latest), ECS Fargate and EC2 modules if interested in deploying applications to this VPC.

## QUICK START

No inputs required unless you want to change defaults. This will create a VPC named `TF_VPC` in `us-east-1`.

```bash
module "vpc" {
  source  = "ryanef/vpc/aws"
  version = "1.2.2"
}
```

An [example](#example-vpc) at the end of this README to show some common default configuration changes.

## NETWORKING DEFAULTS

### INTERNET ACCESS

By default an Internet Gateway is created so anything you create in a public subnet will be able to reach that through settings in the route table.

`NAT Gateway` is optional, you can enable NAT at the `use_nat_gateway` option in *variables.tf* which will also create an Elastic IP.

`VPC Endpoints` are optional and can be changed at `use_nat_gateway` in the *variables.tf* file as well. 

A VPC Endpoint can either be a `Gateway Endpoint` or `Interface Endpoint` you can see an example in the bottom of *variables.tf*. Also keep in mind VPC Endpoints can cost money like NAT Gatway. Both are options for getting internet traffic to your resources running in private subnets.

## Changing Defaults

Most defaults can be changed in `variables.tf`

### VPC CIDR

The default VPC CIDR is `10.10.0.0/20` and can be changed at variable `"vpc_cidr"`

The subnets are using `/25` which give a total of 32 possible subnets.

**Note about Reserved IP addresses in each subnet:**

- 10.10.0.**0** - the network address
- 10.10.0.**1** - Reserved by AWS - VPC Router
- 10.10.0.**2** - Reserved by AWS - DNS server
- 10.10.0.**3** - Reserved by AWS - future use / spare capacity
- 10.0.0.**255** - Network broadcast address although broadcast is not supported in AWS VPCs.

#### Number of subnets to create

In `variables.tf` there are three variables to change. If you want to add more or less, just change the number of CIDRs in the list. I'll add a list of possible /25 subnets at the end of this section.

### PUBLIC SUBNET DEFAULTS

Defaults: `[ "10.10.1.0/25/25", "10.10.3.0/25" ]`

variable `"count_public_cidrs"`

### PRIVATE SUBNET DEFAULTS

Defaults: `[ "10.10.2.0/25", "10.10.4.0/25" ]`

variable `"count_private_cidrs"`

### DATABASE SUBNET DEFAULTS

Defaults: `[ "10.10.10.0/25", "10.10.11.0/25" ]`

variable `"count_database_cidrs"`

I'm using /25 CIDRs which give a total of 32 possible subnets within the 10.10.0.0/20 range of the VPC. A [subnet calculator](https://www.site24x7.com/tools/ipv4-subnetcalculator.html) can help if you want to change this but here's a list of possible /25s you can use for public, private and database CIDR variables:

"10.10.0.0/25", "10.10.0.128/25", "10.10.1.0/25", "10.10.1.128/25", "10.10.2.0/25", "10.10.2.128/25", "10.10.3.0/25", "10.10.3.128/25", "10.10.4.0/25", "10.10.4.128/25", "10.10.5.0/25", "10.10.5.128/25", "10.10.6.0/25", "10.10.6.128/25", "10.10.7.0/25", "10.10.7.128/25", "10.10.8.0/25", "10.10.8.128/25", "10.10.9.0/25", "10.10.9.128/25", "10.10.10.0/25", "10.10.10.128/25", "10.10.11.0/25", "10.10.11.128/25", "10.10.12.0/25", "10.10.12.128/25", "10.10.13.0/25", "10.10.13.128/25", "10.10.14.0/25", "10.10.14.128/25", "10.10.15.0/25", "10.10.15.128/25"

## Example VPC

An example showing how to add extra public and private subnets with NAT Gateway enabled and specifying a custom name for your VPC Name and tags.

```bash
module "vpc" {
  source  = "ryanef/vpc/aws"
  version = "1.2.2"

  count_public_cidrs = ["10.10.1.0/25", "10.10.3.0/25", "10.10.5.0/25", "10.10.7.0/25"]

  count_private_cidrs = ["10.10.2.0/25", "10.10.4.0/25", "10.10.5/0/25"]

  count_database_cidrs = ["10.10.10.0/25", "10.10.11.0/25"]

  environment = "production"

  use_nat_gateway = true
  use_vpc_endpoints = false

  vpc_name = "MyNewVPC"
  vpc_cidr = "10.10.0.0/20"
}
```

Thanks for reading!

[https://ryanf.dev](https://ryanf.dev) for other projects
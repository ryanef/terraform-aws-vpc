# AWS VPC TERRAFORM MODULE

This module is published on Terraform Registry and creates a VPC in us-east-1 by default. This can be changed with `aws_region` variable. By default it will create 2 subnets for three tiers: public, private, database.

SSH at port 22 is enabled in the security group but you will need to change `add_access_ip` variable to *true* and enter your IP address in the `access_ip` variable. As always, treat this as sensitive and manage it appropriately.

## NETWORKING DEFAULTS

For routing, there is a public route table that points to an `Internet Gateway` with a `0.0.0.0/0` CIDR block. The private route table is the VPC's default route table which is private by default.

### INTERNET ACCESS

By default an Internet Gateway is created so anything you create in a public subnet will be able to reach that through settings in the route table.

`NAT Gateway` is optional and remember there is a charge if not on free tier. You can enable NAT at the `use_nat_gateway` option in *variables.tf* which will also create an Elastic IP.

`VPC Endpoints` are optional and can be changed at `use_nat_gateway` in the *variables.tf* file as well. You will have to specify [Endpoint policies(AWS Docs)](https://docs.aws.amazon.com/vpc/latest/privatelink/vpc-endpoints-access.html#default-endpoint-policy) manually because the default grants full access. Documentation shows the default endpoint policy and examples.

A VPC Endpoint can either be a `Gateway Endpoint` or `Interface Endpoint` you can see an example in the bottom of *variables.tf*. Also keep in mind VPC Endpoints can cost money like NAT Gatway. Both are options for getting internet traffic to a private resource.

## Changing Defaults

Most defaults can be changed in `variables.tf`

### VPC CIDR

The default VPC CIDR is `10.10.0.0/20` and can be changed at variable `"vpc_cidr"`

The subnets are using `/25` which give a total of 32 possible subnets. A [subnet calculator](https://www.site24x7.com/tools/ipv4-subnetcalculator.html)

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

Thanks for reading!
https://ryanf.dev for other projects
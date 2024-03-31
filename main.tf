resource "aws_vpc" "this" {

  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = var.instance_tenancy
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  tags = {
    Name = "${local.name_prefix}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.count_public_cidrs)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = var.public_subnet_ip_on_launch
  cidr_block              = var.count_public_cidrs[count.index]
  availability_zone       = local.az[count.index]

  tags = {
    Name = "${local.name_prefix}-public-sn"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.count_private_cidrs)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false
  cidr_block              = var.count_private_cidrs[count.index]
  availability_zone       = local.az[count.index]
  tags = {
    Name        = "${local.name_prefix}-private-sn"
  }
}

resource "aws_subnet" "database_subnet" {
  count                   = length(var.count_database_cidrs)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false
  cidr_block              = var.count_database_cidrs[count.index]
  availability_zone       = local.az[count.index]
  tags = {
    Name        = "${local.name_prefix}-database-sn"

  }
}

resource "aws_db_subnet_group" "rds_subnetgroup" {
  count      = var.create_db_subnet_group ? 1 : 0
  name       = var.subnet_group_name
  subnet_ids = aws_subnet.database_subnet.*.id
  tags = {
    Name        = "${local.name_prefix}-sng"
    Environment = "${local.name_prefix}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.name_prefix}-igw"
    Environment = "${local.name_prefix}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${local.name_prefix}-public-route-table"
    Environment = "${local.name_prefix}"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}


resource "aws_default_route_table" "private_rt" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = {
    Name        = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_eip" "this" {
   count = var.use_nat_gateway ? 1 : 0
  domain   = "vpc"
}

resource "aws_nat_gateway" "this" {
  count = var.use_nat_gateway ? 1 : 0
  allocation_id = aws_eip.this[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT"
  }


  depends_on = [aws_internet_gateway.internet_gateway]
}
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.count_public_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "private_assoc" {
  count          = length(var.count_private_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_default_route_table.private_rt.id
}
resource "aws_route_table_association" "database_assoc" {
  count          = length(var.count_database_cidrs)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_default_route_table.private_rt.id
}
resource "aws_security_group" "default" {
  description = "${var.vpc_name} security group"
  name        = "${var.vpc_name}-ssh"
  vpc_id      = aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    cidr_blocks = var.add_access_ip ? [var.access_ip[0]] : null
    self        = true
    from_port   = 22
    to_port     = 22
  }

  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
    from_port   = 0
    to_port     = 0
  }

  tags = {
    Name        = "${local.name_prefix}-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_vpc_endpoint" "this" {
  for_each = var.use_endpoints ? {for k, v in var.vpc_endpoint : k => v} : var.vpc_endpoint
 vpc_id = aws_vpc.this.id
 service_name = each.value.service_name
#  policy = each.value.policy
 
 private_dns_enabled = each.value.private_dns_enabled
 ip_address_type = each.value.ip_address_type

#  dns_options {
#   dns_record_ip_type =each.value.dns_record_ip_type
#   private_dns_only_for_inbound_resolver_endpoint = each.value.private_dns_only_for_inbound_resolver_endpoint
#  }
 route_table_ids = each.value.route_table_ids
 security_group_ids =each.value.security_group_ids
 subnet_ids = each.value.subnet_ids
 vpc_endpoint_type = each.value.vpc_endpoint_type
 tags = {
   Name =  "${local.name_prefix}-${each.key}"
 }
}

# resource "aws_vpc_endpoint_policy" "example" {
#   for_each = var.use_endpoints ? {for k,v in local.policies  : k=>v} : {}
#   vpc_endpoint_id = each.value.vpc_endpoint_id
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "AllowAll",
#         "Effect" : each.value.effect,
#         "Principal" : {
#           "AWS" : "${each.value.principal}"
#         },
#         "Action" : [
#           "${each.value.action}"
#         ],
#         "Resource" : "${each.value.resource}"
#       }
#     ]
#   })
#   depends_on = [ aws_vpc_endpoint.this ]
# }
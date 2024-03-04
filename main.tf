resource "aws_vpc" "this" {

  cidr_block                           = var.vpc_cidr
  instance_tenancy                     = var.instance_tenancy
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics

  tags = {
    Name = "${var.vpc_name}-${var.environment}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = var.public_subnet_ip_on_launch
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = local.az[count.index]

  tags = {
    Name = "${var.vpc_name}-${var.environment}-public-sn"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_cidr)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false
  cidr_block              = var.private_cidr[count.index]
  availability_zone       = local.az[count.index]
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-private-sn"
    Environment = "${var.vpc_name}-${var.environment}"
  }
}

resource "aws_subnet" "database_subnet" {
  count                   = length(var.database_cidr)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false
  cidr_block              = var.database_cidr[count.index]
  availability_zone       = local.az[count.index]
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-database-sn"
    Environment = "${var.vpc_name}-${var.environment}"
  }
}

resource "aws_db_subnet_group" "rds_subnetgroup" {
  count      = var.create_db_subnet_group ? 1 : 0
  name       = var.subnet_group_name
  subnet_ids = aws_subnet.database_subnet.*.id
  tags = {
    Name        = "${var.vpc_name}-${var.environment}-sng"
    Environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-igw"
    Environment = "${var.vpc_name}-${var.environment}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-public-route-table"
    Environment = "${var.vpc_name}-${var.environment}"
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
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
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

  tags = {
    Name        = "${var.vpc_name}-${var.environment}-sg"
    Environment = "${var.environment}"
  }
}
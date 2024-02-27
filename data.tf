data "aws_availability_zones" "available" {
  state         = "available"
  exclude_names = var.az_exclude_names
}
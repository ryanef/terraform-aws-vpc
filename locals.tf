locals {
  azs = data.aws_availability_zones.available.names

  security_groups = {
    public = {
      name        = "public_sg"
      description = "publicsg"
      ingress = {
        ssh = {
          to          = 22
          from        = 22
          cidr_blocks = [var.access_ip]
          protocol    = "tcp"
        }
        http = {
          to          = 80
          from        = 80
          cidr_blocks = ["0.0.0.0/0"]
          protocol    = "tcp"
        }
        # target_group = {
        #     to = var.target_group_to
        #     from = var.target_group_from
        #     cidr_blocks = [var.target_group_cidr_blocks]
        #     protocol = var.target_group_protocol
        # }
      }
    }
  }
}
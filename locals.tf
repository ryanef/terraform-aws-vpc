locals {
  az = data.aws_availability_zones.available.names


  security_groups = {

    public = {
      name        = "public_sg"
      description = "public_sg"
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

      }
    }
  }
}
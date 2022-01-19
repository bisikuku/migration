locals {
  vpc_cidr = "10.220.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "nfs_sg",
      description = "Public SG",
      ingress = {
        ssh = {
          from_port   = 22,
          to_port     = 22,
          protocol    = "tcp",
          cidr_blocks = [var.access_ip]
        }
        http = {
          from_port   = 80,
          to_port     = 80,
          protocol    = "tcp",
          cidr_blocks = [var.access_ip]
        }
        http = {
          from_port   = 80,
          to_port     = 80,
          protocol    = "tcp",
          cidr_blocks = [var.access_ip]
        }
        https = {
          from_port   = 443,
          to_port     = 443,
          protocol    = "tcp",
          cidr_blocks = [var.access_ip]
        }

      }
    }
    rds = {
      name        = "rds_sg",
      description = "Private rds",
      ingress = {
        mysql = {
          from_port   = 3306,
          to_port     = 3306,
          protocol    = "tcp",
          cidr_blocks = [local.vpc_cidr]
        }

      }
    }
  }
}



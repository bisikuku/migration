# ----root/main.tf -----

# terraform {
#   backend "s3" {
#   bucket = "tdoc2-prod-terraform-state" 
#   key = "terraform.tfstate"
#   region = "us-west-1" 
#   profile = "default" 
#   } 
# }

module "networking" {
  source           = "./networking"
  access_ip        = var.access_ip
  vpc_cidr         = local.vpc_cidr
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 5
  max_subnets      = 20
  public_cidr      = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidr     = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = false
}

# module "database" {
#   source                 = "./database"
#   db_storage             = 10
#   db_instance_class      = "db.t2.micro"
#   db_engine_version      = "5.7.22"
#   dbuser                 = var.dbuser
#   dbpass                 = var.dbpass
#   db_skip_final_snapshot = true
#   db_identifier          = "nfs-db"
#   vpc_security_group_ids = module.networking.db_security_group
#   db_subnet_group_name   = module.networking.db_subnet_group[0]

# }

module "loadbalancer" {
  source           = "./loadbalancer"
  lb_public_sg     = module.networking.public_sg
  lb_public_subnet = module.networking.public_subnet[0]
  #lb_private_subnet = module.networking.private_subnet
  lb_name         = "tela-lb"
  lb_type         = "application"
  lb_facing       = false
  lb_protocol     = "HTTP"
  lb_port         = 80
  lb_port_ssl     = 443
  lb_protocol_ssl = "HTTPS"
  lb_ssl_policy   = "ELBSecurityPolicy-2016-08"
  lb_vpc          = module.networking.vpc_id
  lb_tg_arn       = module.loadbalancer.tg_arn
  lb_cert_arn     = module.certificate.cert_arn
}

module "ami" {
  source             = "./ami"
  source_instance_id = var.source_instance_id
  ami_name           = var.ami_name
  account_id = var.account_id
  destination = var.destination
  copyname = var.copyname
  profile = var.profile
  aws_region = var.aws_region
  name = var.name
  aws_source_region = var.aws_source_region
}

module "certificate" {
  source            = "./certificate"
  domain_name       = "brickscourt.com"
  validation_method = "DNS"
  Environment       = "production"
  cert_ttl          = 60
  cert_arn          = module.certificate.cert_arn
}

module "compute" {
  source        = "./compute"
  ami           = module.ami.ami_id
  public_sg     = module.networking.public_sg
  public_subnet = module.networking.public_subnet[0]
  instance_type = "t3.micro"
  #instance_count = 1
  volume_size = 10
  volume_type = "gp3"
}

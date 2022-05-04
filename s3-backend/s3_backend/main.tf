# ################
# # AWS Provider #

# # -----main - folder-----
# # Declaring the Provider Requirements when Terraform 0.13 and later is installed
# terraform {
#   # A provider requirement consists of a local name (aws), 
#   # source location, and a version constraint. 
#   required_providers {
#     aws = {
#       # Declaring the source location/address where Terraform can download plugins
#       source = "hashicorp/aws"
#       # Declaring the version of aws provider as greater than 3.0 
#     }
#   }
# }

# # Declaring an AWS provider named aws
# provider "aws" {
#   region                  = "us-west-2"
#   shared_credentials_file = "/root/.aws/profile"
#   profile                 = "profile"
# }
  

locals {
  common_tags = {
    EnvClass  = var.env_class
    Owner     = "telprod" # Possible variants: DevOPS, ProdOPS, John Smith
    Terraform = "true"
  }
}

#######################
# Creating S3 backend #
#######################

# This module creating S3 backend for environment
module "s3-state" {
  source = "../s3-state"

  env_class                  = var.env_class
  create_dynamodb_lock_table = var.create_dynamodb_lock_table
  create_s3_bucket           = var.create_s3_bucket
  common_tags                = local.common_tags
}


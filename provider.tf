# -----main - folder-----
# Declaring the Provider Requirements when Terraform 0.13 and later is installed
terraform {
  # A provider requirement consists of a local name (aws), 
  # source location, and a version constraint. 
  required_providers {
    aws = {
      # Declaring the source location/address where Terraform can download plugins
      source = "hashicorp/aws"
      # Declaring the version of aws provider as greater than 3.0 
    }
  }
}

# Declaring an AWS provider named aws
provider "aws" {
  region                  = var.aws_region
  shared_credentials_file = "/root/.aws/profile"
  profile                 = "profile"
}
  
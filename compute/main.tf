locals {
  enabled        = module.this.enabled
  instance_count = local.enabled ? 1 : 0
  instance_name  = module.this.name
}



# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"]

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# resource "random_id" "randomy" {
#   byte_length = 2
#   count = var.instance_count
# }

resource "aws_instance" "tela_instance" {
  count                  = local.instance_count
  ami                    = var.ami # us-west-2
  instance_type          = var.instance_type
  tags                   = module.this.tags
  vpc_security_group_ids = var.public_sg
  subnet_id              = var.public_subnet[count.index]

}


# module "label" {
#   source     = "../../terraform-null-label"
#   namespace  = "${var.namespace}"
#   stage      = "${var.stage}"
#   name       = "${var.name}"
#   attributes = "${var.attributes}"
#   delimiter  = "${var.delimiter}"
#   tags       = "${var.tags}"
# }

# resource "aws_ami_from_instance" "default" {
#   name                    = "ok"
#   source_instance_id      = "${var.source_instance_id}"
#   snapshot_without_reboot = "${var.snapshot_without_reboot}"
#   tags                    = "${module.label.tags}"

#   lifecycle {
#     create_before_destroy = true
#   }
# }
resource "aws_ami_from_instance" "default" {
  name               = var.ami_name
  source_instance_id = var.source_instance_id
}

resource "null_resource" "copyami" {
  provisioner "local-exec" {
    command = "aws ec2 copy-image --source-image-id ${aws_ami_from_instance.default.id}   --source-region ${var.aws_source_region} --region ${var.destination} --name ${var.copyname} --profile ${var.profile} "
  }
}



# resource "aws_ami_from_instance" "default" {
#   name               = var.ami_name
#   source_instance_id = var.source_instance_id
# }

# resource "aws_ami_copy" "tela_ami" {
#   name              = "ami-copy"
#   description       = "A copy of ami"
#   source_ami_id     = aws_ami_from_instance.default.id
#   source_ami_region = "us-west-2"

#   tags = {
#     Name = "terraform-ami-copy"
#   }
# }


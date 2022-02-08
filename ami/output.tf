# output "ami_id" {
#   value = aws_ami_from_instance.default.id
# }

output "ami_id" {
  value = aws_ami_launch_permission.share_ami.image_id
}
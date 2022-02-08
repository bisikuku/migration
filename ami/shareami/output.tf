output "ami_id" {
  value = aws_ami_from_instance.default.id
}

output "copy_ami_id" {
  value = null_resource.copyami.id
}



resource "aws_ami_from_instance" "tela_ami" {
  name               = var.ami_name
  source_instance_id = var.source_instance_id
}

resource "aws_ami_launch_permission" "share_ami" {
  image_id   = aws_ami_from_instance.tela_ami.id
  account_id = var.account_id

  depends_on = [
    aws_ami_from_instance.tela_ami
  ]
}


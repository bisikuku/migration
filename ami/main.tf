

module shareami {
  source = "./shareami"
  ami_name = "shareami"
  source_instance_id = var.source_instance_id
  destination = var.destination
  copyname = var.copyname
  profile = var.profile
  aws_region = var.aws_region
  name = var.name
  aws_source_region = var.aws_source_region
}

data "aws_ami" "wordpressami" {
  most_recent      = true
  owners = ["992398866380"]

  filter {
    name = "name"
    values = ["wordpress"]
  }
}

resource "aws_ami_launch_permission" "share_ami" {
  image_id   = data.aws_ami.wordpressami.id
  account_id = var.account_id

  depends_on = [module.shareami.copy_ami_id]
}


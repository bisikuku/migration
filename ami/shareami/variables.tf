#variable "account_id" {}
variable "ami_name" {}
variable "aws_source_region" {}
variable "aws_region" {}
variable "destination" {}
variable "copyname" {}
variable "profile" {}




#-----------------------#

variable "name" {
  default     = ""
  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
}

variable "namespace" {
  default     = ""
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "source_instance_id" {}

variable "snapshot_without_reboot" {
  default = "true"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
    default = []

}

variable "tags" {
  default     = {}
}

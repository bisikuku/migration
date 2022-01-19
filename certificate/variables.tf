variable "domain_name" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "Environment" {}
variable "validation_method" {}
variable "cert_ttl" {}
variable "process_domain_validation_options" {
  type        = bool
  default     = true
  description = "Flag to enable/disable processing of the record to add to the DNS zone to complete certificate validation"
}
variable "zone_name" {
  type        = string
  default     = ""
  description = "The name of the desired Route53 Hosted Zone"
}
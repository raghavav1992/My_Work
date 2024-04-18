variable "region" {
  description = "The region into which the VPC is deployed, e.g. eu-central-1."
  type        = string
  default     = "ap-south-1"
}

variable "profile" {
  description = "profile to be used for the Authentication purpose."
  type        = string
  default     = "ragpra"
}

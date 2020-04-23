
# you need to specify a SSH key that exists in your AWS account
variable "key_name" {
  default = "760test"
}

variable "ami" {
  default = "ami-0a6a8f40c0082d6eb"
}

variable "instance_type" {
  default = "m4.xlarge"
}
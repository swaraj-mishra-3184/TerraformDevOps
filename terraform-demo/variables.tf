variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "instance_name" {
  description = "EC2 Name"
  type        = string
}

variable "ami_id" {
  description = "Amazon Machine Image ID"
  type        = string
}

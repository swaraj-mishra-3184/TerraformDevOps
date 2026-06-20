provider "aws" {
  region = "us-east-2"
}

variable "users" {
  default = [
    "itw",
    "itw",
    "sm",
    "sm",
    "ingenious"
  ]
}

resource "aws_iam_user" "users" {
  for_each = toset(var.users)

  name = each.value
}

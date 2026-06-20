# 1. Install Terraform


# Install required packages
sudo dnf install -y dnf-plugins-core

# Add HashiCorp repository
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform
sudo dnf install -y terraform

# Verify installation
terraform version


# 2. Create an user for terraform provide sudo access to it and configure aws cli in it

sudo useradd -m -s /bin/bash terraform

echo "terraform ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform
sudo chmod 440 /etc/sudoers.d/terraform

sudo visudo -c

sudo su - terraform

sudo dnf install -y awscli

aws --version

# 3. script with no variables
provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0741dc526e1106ae5"
  instance_type = "t3.micro"

  tags = {
    Name = "web-server"
  }
}

resource "aws_iam_user" "user" {
  name = "itw@anonymous"
}

# 4. Numbers introduced in script
provider "aws" {
  region = "us-east-2"
}

variable "instance_count" {
  default = 3
}

resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "ami-0741dc526e1106ae5"
  instance_type = "t3.micro"

  tags = {
    Name = "web-${count.index}"
  }
}

# 5.String Introduced
provider "aws" {
  region = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = var.instance_type

  tags = {
    Name = "web-server"
  }
}

# 6. Lists introduced
Deploy servers in multiple zones
provider "aws" {
  region = "us-east-2"
}

variable "availability_zones" {
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
}

resource "aws_instance" "web" {
  count             = length(var.availability_zones)
  ami               = "ami-0741dc526e1106ae5"
  instance_type     = "t3.micro"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "web-${count.index}"
  }
}

# 7. List of IAM Users
provider "aws" {
  region = "us-east-1"
}

variable "users" {
  default = [
    "john",
    "mary",
    "david"
  ]
}

resource "aws_iam_user" "employees" {
  count = length(var.users)

  name = var.users[count.index]
}

# 8. Map Variable
provider "aws" {
  region = "us-east-2"
}

variable "instance_types" {
  default = {
    dev  = "t3.micro"
    test = "t3.small"
    prod = "m7i-flex.large"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0741dc526e1106ae5"
  instance_type = var.instance_types["prod"]

  tags = {
    Name = "production-server"
  }
}

# 9. Object Variable
provider "aws" {
  region = "us-east-2"
}

variable "server_config" {
  default = {
    instance_type = "t3.micro"
    user_name     = "itw"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0741dc526e1106ae5"
  instance_type = var.server_config.instance_type
}

resource "aws_iam_user" "user" {
  name = var.server_config.user_name
}

#0. Set Variable
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


terraform-demo/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── main.tf
└── outputs.tf

## provider.tf
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

## variables.tf
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

##terraform.tfvars
aws_region   = "us-east-2"
instance_type = "t3.small"
instance_name = "terraform-demo-server"
ami_id        = "ami-0741dc526e1106ae5"

##main.tf
resource "aws_instance" "web" {

  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

## outputs.tf
output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}




#validate terraform scripts
terraform validate





Challenges for lab:
1. Using terraform create an ec2 with public ip and modify
associate_public_ip_address = false


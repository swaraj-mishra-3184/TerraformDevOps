# Terraform AWS DevOps Lab

A hands-on Terraform repository for learning Infrastructure as Code (IaC) using Terraform with AWS.

This repository contains Terraform examples covering:

* Terraform installation
* AWS provider configuration
* EC2 provisioning
* IAM user creation
* Terraform variables
* Count
* Lists
* Maps
* Objects
* Sets
* Terraform project structure
* Terraform validation
* AWS EC2 public/private IP configuration

---

# Repository Structure

```text
TerraformDevOps/
│
├── README.md
│
├── install_tf.setup.sh
│
├── tf_user_aws.setup.sh
│
├── main.tf
├── main.tf_number
├── main.tf_string
├── main.tf_lists
├── main.tf_map
├── main.tf_obj
├── main.tf_boolean
│
└── terraform-demo/
    │
    ├── provider.tf
    ├── variables.tf
    ├── terraform.tfvars
    ├── main.tf
    └── output.tf
```

---

# Prerequisites

Before starting, ensure you have:

* AWS Account
* AWS IAM User with programmatic access
* Amazon Linux EC2 Instance
* Terraform installed
* AWS CLI configured
* Git installed

---

# 1. Install Terraform

Install required packages:

```bash
sudo dnf install -y dnf-plugins-core
```

Add HashiCorp repository:

```bash
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```

Install Terraform:

```bash
sudo dnf install -y terraform
```

Verify:

```bash
terraform version
```

---

# 2. Create Terraform User and Configure AWS CLI

Create terraform user:

```bash
sudo useradd -m -s /bin/bash terraform
```

Provide sudo permission:

```bash
echo "terraform ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/terraform

sudo chmod 440 /etc/sudoers.d/terraform
```

Validate:

```bash
sudo visudo -c
```

Switch user:

```bash
sudo su - terraform
```

Install AWS CLI:

```bash
sudo dnf install -y awscli
```

Verify:

```bash
aws --version
```

Configure AWS:

```bash
aws configure
```

---

# Terraform Workflow

## Initialize Terraform

Downloads required providers.

```bash
terraform init
```

---

## Validate Configuration

Checks Terraform syntax.

```bash
terraform validate
```

Example output:

```text
Success! The configuration is valid.
```

---

## Plan Infrastructure

Shows changes Terraform will make.

```bash
terraform plan
```

---

## Deploy Infrastructure

Creates AWS resources.

```bash
terraform apply
```

---

## Destroy Infrastructure

Deletes resources.

```bash
terraform destroy
```

---

# Terraform Examples

## 1. Basic Terraform Script

Creates:

* EC2 Instance
* IAM User

Example:

```hcl
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
```

---

# 2. Number Variable

Using `count` to create multiple instances.

Example:

```hcl
variable "instance_count" {
  default = 3
}

resource "aws_instance" "web" {

  count = var.instance_count

  ami = "ami-0741dc526e1106ae5"

  instance_type = "t3.micro"

  tags = {
    Name = "web-${count.index}"
  }
}
```

Creates:

```text
web-0
web-1
web-2
```

---

# 3. String Variable

Example:

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

Used:

```hcl
instance_type = var.instance_type
```

---

# 4. List Variable

Deploy EC2 instances across multiple Availability Zones.

Example:

```hcl
variable "availability_zones" {

default = [

"us-east-2a",
"us-east-2b",
"us-east-2c"

]

}
```

---

# 5. IAM Users Using List

Example:

```hcl
variable "users" {

default = [

"john",
"mary",
"david"

]

}
```

Creates multiple IAM users.

---

# 6. Map Variable

Manage different environments.

Example:

```hcl
variable "instance_types" {

default = {

dev  = "t3.micro"

test = "t3.small"

prod = "m7i-flex.large"

}

}
```

Usage:

```hcl
instance_type = var.instance_types["prod"]
```

---

# 7. Object Variable

Store multiple configuration values.

Example:

```hcl
variable "server_config" {

default = {

instance_type = "t3.micro"

user_name = "itw"

}

}
```

Usage:

```hcl
var.server_config.instance_type
```

---

# 8. Set Variable

Removes duplicate values automatically.

Example:

```hcl
variable "users" {

default = [

"itw",
"itw",
"sm",
"sm",
"ingenious"

]

}
```

Using:

```hcl
for_each = toset(var.users)
```

Creates unique IAM users.

---

# Terraform Project Structure

The recommended Terraform layout:

```text
terraform-demo/

├── provider.tf

├── variables.tf

├── terraform.tfvars

├── main.tf

└── output.tf
```

---

# Provider Configuration

File:

`provider.tf`

```hcl
terraform {

required_version = ">=1.0"

required_providers {

aws = {

source = "hashicorp/aws"

version = "~>6.0"

}

}

}


provider "aws" {

region = var.aws_region

}
```

---

# Variables

File:

`variables.tf`

Contains:

* AWS Region
* Instance Type
* Instance Name
* AMI ID

Example:

```hcl
variable "aws_region" {

type = string

}
```

---

# Terraform Variables Values

File:

`terraform.tfvars`

Example:

```hcl
aws_region = "us-east-2"

instance_type = "t3.small"

instance_name = "terraform-demo-server"

ami_id = "ami-0741dc526e1106ae5"
```

---

# Outputs

File:

`output.tf`

Example:

```hcl
output "instance_id" {

value = aws_instance.web.id

}


output "public_ip" {

value = aws_instance.web.public_ip

}
```

---

# Lab Challenges

## Challenge 1: Create EC2 With Public IP

Create an EC2 instance:

```hcl
resource "aws_instance" "web" {

ami = "ami-0741dc526e1106ae5"

instance_type = "t3.micro"

associate_public_ip_address = true

tags = {

Name = "public-server"

}

}
```

Verify:

```bash
terraform apply
```

Check EC2 Public IPv4 address.

---

# Challenge 2: Convert EC2 To Private Instance

Modify:

```hcl
associate_public_ip_address = false
```

Apply:

```bash
terraform apply
```

Expected:

* Instance does not receive public IP
* Instance becomes private
* Access requires private networking methods

---

# Important Files Ignored

The following files should never be committed:

```text
.terraform/

*.tfstate

*.tfstate.*

terraform.tfstate.backup
```

They are excluded using `.gitignore`.

---

# Learning Objectives

After completing this lab, you will understand:

✅ Terraform installation
✅ AWS provider configuration
✅ EC2 provisioning
✅ IAM resources
✅ Terraform variables
✅ Count and loops
✅ Lists and Maps
✅ Object and Set variables
✅ Terraform project structure
✅ Terraform state management
✅ Infrastructure lifecycle management

---

# Author

Terraform AWS DevOps Lab

Repository:

`TerraformDevOps`

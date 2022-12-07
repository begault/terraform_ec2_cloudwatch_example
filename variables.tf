variable "region" {
  type    = string
  description = "AWS deployment region"
}

variable "project_name" {
  type    = string
  description = "The global name of the project"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

variable "owner" {
  type    = string
  default = "default"
}

variable "automation" {
  type    = string
  default = "Terraform"
}

//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

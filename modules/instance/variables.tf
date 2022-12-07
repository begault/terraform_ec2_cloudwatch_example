variable "vpc_id" {
  type        = string
  description = "The id of the vpc"
}

variable "project_name" {
  type        = string
  description = "The global name of the project"
}

variable "public_subnet_id" {
  type        = string
  description = "The id of the public subnet"
}

variable "public_subnet_ids" {
  type        = list(any)
  description = "The ids of the public subnets"
}

variable "region" {
  type        = string
  description = "The region to launch the instance host"
}

variable "environment" {
  type        = string
  description = "The Deployment environment"
}

variable "owner" {
  type        = string
  description = "The Deployment owner"
}

variable "automation" {
  type        = string
  description = "The Deployment automation"
}
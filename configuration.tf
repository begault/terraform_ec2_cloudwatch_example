# Definition des tags par defaut du projet
locals {
  default_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    Automation  = var.automation
  }
}

# Informations à fournir au provider AWS
# pour la mise en place de l'infrastructure
provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = local.default_tags
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.69.0"
    }
  }
}
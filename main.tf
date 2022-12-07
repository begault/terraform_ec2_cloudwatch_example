/* Récupération de la liste des zones AWS disponibles */
data "aws_availability_zones" "available" {
  state = "available"
}

###########
# VPC
###########

module "networking" {
  source               = "./modules/networking"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr  
  availability_zones   = data.aws_availability_zones.available.names
}

#############
# Cloudwatch
#############

module "cloudwatch" {
  source       = "./modules/cloudwatch"
  project_name = var.project_name
}

###########
# EC2
###########

module "instance" {
  source                 = "./modules/instance"
  region                 = var.region
  project_name           = var.project_name
  environment            = var.environment
  owner                  = var.owner
  automation             = var.automation

  depends_on             = [module.networking, module.cloudwatch]
  
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnets_ids
  public_subnet_id       = element(module.networking.public_subnets_ids, 0)
}
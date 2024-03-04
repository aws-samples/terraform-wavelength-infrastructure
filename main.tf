#Creating VPC using local module
module "vpc" {
  source                           = "./modules/vpc"
  vpc_cidr                         = var.vpc_cidr
  identifier                       = var.project_identifier
  wavelength_subnet_identifier = var.wavelength_subnet_identifier
  wavelength_subnet_cidrs      = var.wavelength_subnet_cidr
  availabilityzone_wavelength  = var.availabilityzone_wavelength
}

#Creating EC2 instances using local module
module "compute" {
  source                             = "./modules/compute"
  ec2_count                          = var.ec2_count
  instance_type_wavelength       = var.instance_type_wavelength
  instance_identifier_wavelength = var.instance_identifier_wavelength
  availabilityzone_wavelength    = var.availabilityzone_wavelength
  instance_subnet_wavelength     = module.vpc.wavelength_subnet
}

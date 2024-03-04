variable "region" {
  description = "AWS Region"
  type        = string
}
variable "vpc_cidr" {
  description = "AWS VPC CIDR"
  type        = string
}

variable "project_identifier" {
  type        = string
  description = "Project Name, used as identifer when creating resources."
  default     = "VPC_Wavelength"
}
variable "instance_identifier_wavelength" {
  type        = string
  description = "wavelength identifier"
  default     = "EC2_Wavelength"
}

variable "wavelength_subnet_identifier" {
  type        = string
  description = "Project Name, used as identifer when creating resources."
  default     = "Wavelength_Subnet"
}
variable "wavelength_subnet_cidr" {
  description = "wavelength subnet cidr"
  type        = string
}
variable "availabilityzone_wavelength" {
  type        = string
  description = "Availability Zone for wavelength zone"
}

variable "instance_type_wavelength" {
  type        = string
  description = "EC2 instance type for wavelength"
  default     = "r5.2xlarge"
}
variable "ec2_count" {
  type        = number
  default     = 1
  description = "Number of EC2 instances to create"
}

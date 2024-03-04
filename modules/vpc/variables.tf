variable "identifier" {
  type        = string
  description = "Project identifier."
}
variable "wavelength_subnet_identifier" {
  type        = string
  description = "Wavelength subnet identifier."
}
variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR block for the VPC"
}

variable "wavelength_subnet_cidrs" {
  type        = string
  description = "IPv4 CIDR block for the Wavelength Subnet"
}

variable "availabilityzone_wavelength" {
  type        = string
  description = "Availability Zones for wavelength zone"
}


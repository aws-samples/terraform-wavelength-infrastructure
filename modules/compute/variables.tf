variable "instance_type_wavelength" {
  type        = string
  description = "EC2 instance type for wavelength"
}

variable "instance_identifier_wavelength" {
  type        = string
  description = "EC2 wavelength instance name"
}

variable "instance_subnet_wavelength" {
  description = "Subnet for wavelength"
  type        = any
}

variable "ec2_count" {
  type        = number
  description = "Number of EC2 instances to create"
}
variable "availabilityzone_wavelength" {
  type        = string
  description = "Availability Zones - WLZ"
}
variable "key_pair_algo" {
  type = string
  description = "Values for keypair generation"
  default = "RSA" 
}
variable "key_pair_name" {
  type = string
  description = "Values for keypair generation"
  default = "EC2-key-pair"
}

variable "key_pair_rsabits" {
  type = number
  description = "Values for keypair generation"
  default = 4096
}
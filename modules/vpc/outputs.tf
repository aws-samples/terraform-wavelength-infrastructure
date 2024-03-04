output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "wavelength_subnet" {
  value       = aws_subnet.wavelength_subnets.id
  description = "Wavelength Subnet created."
}
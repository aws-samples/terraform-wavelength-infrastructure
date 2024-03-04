output "ec2_instance_carriergateway" {
  value       = aws_instance.ec2_instance_wavelength.id
  description = "EC2 Created."
}
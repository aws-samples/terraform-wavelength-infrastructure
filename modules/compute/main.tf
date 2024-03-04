data "aws_caller_identity" "current" {}
# Data source for AMI used by EC2 instances
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.3.20240131.0-kernel-6.1-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Creating Wavelength zone EC2 instance
resource "aws_instance" "ec2_instance_wavelength" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type_wavelength
  subnet_id     = var.instance_subnet_wavelength
  key_name      = aws_key_pair.ec2-key-pair.key_name
  monitoring    = true
  ebs_optimized = true
  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs-kms-key.key_id 
    delete_on_termination = true
  }
  metadata_options {

       http_endpoint = "enabled"
       http_tokens   = "required"
  }
  tags = {
    Name = var.instance_identifier_wavelength
  }
}
# Creates a key for EC2 Wavelength
resource "aws_key_pair" "ec2-key-pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}
# Generates a private key
resource "tls_private_key" "rsa" {
  algorithm = var.key_pair_algo
  rsa_bits  = var.key_pair_rsabits
}
# Creates a local copy of key
resource "local_file" "ec2-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = var.key_pair_name
}

# Resource creating key to encrypt EBS
resource "aws_kms_key" "ebs-kms-key" {
  description              = "EBS KMS Key"
  deletion_window_in_days  = 7
  enable_key_rotation     = true
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

    tags = {
    Name = "EBS KMS Key"
  }
}
# Policy used by KMS key
resource "aws_kms_key_policy" "kms_key_policy" {
  key_id = aws_kms_key.ebs-kms-key.id
  policy = jsonencode({
    Id = "KMS Key for EBS"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }

        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}
# KMS Key alias
resource "aws_kms_alias" "ebs-key" {
  name          = "alias/EBS-KMS-Key"
  target_key_id = aws_kms_key.ebs-kms-key.key_id
}

#Creation of Elastic IP for Wavelength EC2
resource "aws_eip" "wavelength_ip" {
  network_border_group = var.availabilityzone_wavelength
  instance             = aws_instance.ec2_instance_wavelength.id

  tags = {
    Name = "Wavelength EC2 EIP"
  }
}

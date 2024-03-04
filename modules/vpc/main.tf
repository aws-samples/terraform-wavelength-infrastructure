data "aws_caller_identity" "current" {}
#Use current region
data "aws_region" "current" {}

#Creating VPC in desired region
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.identifier
  }
}

#Creating a Carrier Gateway and attaching to VPC
resource "aws_ec2_carrier_gateway" "carrier_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Carrier_Gateway"
  }
}

#Creating subnet for EC2 in wavelength zone
resource "aws_subnet" "wavelength_subnets" {

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.wavelength_subnet_cidrs
  availability_zone = var.availabilityzone_wavelength
  tags = {
    Name = var.wavelength_subnet_identifier
  }
}

# Wavelength routetable
resource "aws_route_table" "vpc_routetable_wavelength" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block         = "0.0.0.0/0"
    carrier_gateway_id = aws_ec2_carrier_gateway.carrier_gateway.id
  }
  tags = {
    Name = "Wavelength_Routetable"
  }
}

#Association of Wavelength subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.wavelength_subnets.id
  route_table_id = aws_route_table.vpc_routetable_wavelength.id

}

# Resource that creates VPC flow log
resource "aws_flow_log" "vpc_flow" {
  iam_role_arn    = aws_iam_role.vpc_flow_iamrole.arn
  log_destination = aws_cloudwatch_log_group.cloudwatch_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id

    tags = {
    Name = "VPC Flow Logs"
  }
}

# Create CloudWatch log group
resource "aws_cloudwatch_log_group" "cloudwatch_log" {
  name = "VPC_Flow_Log"
  kms_key_id = aws_kms_key.cloudwatchkey.arn
}

# Data resource used by IAM Role for VPC Flow Logs
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:vpc-flow-log/*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

# IAM Role for VPC Flow log
resource "aws_iam_role" "vpc_flow_iamrole" {
  name               = "VPC_Flow_log_IAM_Role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Data policy used by VPC IAM Role Policy
data "aws_iam_policy_document" "vpc_flow_iampolicy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

# IAM Role Policy used by IAM Role for VPC Flow Log
resource "aws_iam_role_policy" "vpc_flow_iamrolepolicy" {
  name   = "VPC_Flow_iam_role_policy"
  role   = aws_iam_role.vpc_flow_iamrole.id
  policy = data.aws_iam_policy_document.vpc_flow_iampolicy.json
}

# resource creating KMS key for CloudWatch
resource "aws_kms_key" "cloudwatchkey" {
  description             = "This key is for cloudwatch log"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.policy_kms_logs_document.json
     tags = {
    Name = "CloudWatch KMS Key"
  }
}
# KMS Policy - it allows the use of the Key by the CloudWatch log groups
data "aws_iam_policy_document" "policy_kms_logs_document" {
  statement {
    sid       = "Enable IAM User Permissions"
    actions   = ["kms:*"]
    resources = ["arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid = "Enable KMS to be used by CloudWatch Logs"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}
# KMS key Alias for cloudwatch key
resource "aws_kms_alias" "cloudwatch-key-alias" {
  name          = "alias/CloudWatch-KMS-Key"
  target_key_id = aws_kms_key.cloudwatchkey.key_id
}
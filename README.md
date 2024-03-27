# Creating AWS Wavelength Infrastructure using Terraform

This solution demonstrates the deployment of infrastructure to support a 5G application in an AWS Wavelength zone using Terraform, the repository will create the foundation your 5G application needs by utilising AWS services and ensuring best practice.

## Solution Overview

<img src = "https://github.com/aws-samples/terraform-wavelength-infrastructure/assets/139151193/a5122fa3-acac-42c9-9bc3-362410e27882">

## Prerequisites

* Active AWS account

* Integrated Development Environment (IDE)

* Opt-in to required AWS Wavelength Zones

## Installation

### Step 1: Clone this repository.
```
git@github.com:aws-samples/terraform-wavelength-infrastructure.git
```
Note: if git is not installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Step 2: Create a terraform.tfvars file.
Create the following variables and enter values:
* `region`
* `vpc_cidr`
* `wavelength_subnet_cidr`
* `availabilityzone_wavelength`

Save the file once this step is complete.


### Step 3: Initialise the directory.
```
terraform init
```
## Deployment

### Step 1: Run a plan to see the output of the infrastructure.
```
terraform plan
```

### Step 2: Apply infrastructure.
```
terraform apply
```

## Validation
* Login to AWS account using AWS console
* To get started with AWS Wavelength, [follow these five steps documented here.](https://aws.amazon.com/wavelength/getting-started/)

## (Optional) Clean up the infrastructure 
* Enter the following command to clean up
```
terraform destroy
```

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.


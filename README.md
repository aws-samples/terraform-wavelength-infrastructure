# Creating AWS Wavelength Infrastructure using Terraform

## Getting Started

Check out this related AWS Prescriptive Guidance pattern on deployment: [Deploy resources and services within an AWS Wavelength Zone and associated AWS Region using Terraform](https://apg-library.amazonaws.com/content-viewer/author/8c507de1-208c-4563-bb58-52388ab2fa6d)

## Prerequisites

* Active AWS account

* AWS Cloud9 environment

* Opt-in to required AWS Wavelength Zones

## Installation

### Step 1: Clone this repository.
```
git@github.com:aws-samples/terraform-wavelength-infrastructure.git
```
Note: if git is not installed, [install git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

### Step 2: Create a terraform.tfvars file.
Create the following variables and enter values:
* region
* vpc_cidr
* wavelength_subnet_cidr
* bastion_subnet_cidr
* availabilityzone_wavelength
* availabilityzone_bastion
* my_ip

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
* Connect to `Bastion_EC2` instance and ping the private IP address of `EC2_Carrier_Gateway`


## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.


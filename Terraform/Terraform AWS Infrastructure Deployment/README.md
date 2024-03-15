# Terraform AWS Infrastructure Deployment

This repository contains Terraform code to deploy an AWS infrastructure consisting of a VPC, public and private subnets, NAT Gateway, EC2 instances, and associated security groups.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html) - Version 1.0 or later
- AWS account with appropriate permissions
- AWS CLI configured with access keys

## Usage

1. Clone the repository:

    ```bash
    git clone https://github.com/your-username/terraform-aws-infrastructure.git
    cd terraform-aws-infrastructure
    ```

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Review and customize `terraform.tfvars` file if necessary.

4. Plan the deployment to ensure everything is configured correctly:

    ```bash
    terraform plan
    ```

5. If the plan looks good, apply the changes:

    ```bash
    terraform apply
    ```

6. After deployment, Terraform will output relevant information about the created resources.

## Configuration

- `main.tf`: Contains the main Terraform configuration defining AWS resources.
- `variables.tf`: Declares input variables used throughout the configuration.
- `terraform.tfvars`: Defines values for input variables. Make sure to customize according to your requirements.
- `outputs.tf`: Specifies the outputs to display after deployment.

## Resources Created

- VPC with public and private subnets
- Internet Gateway for public subnet
- NAT Gateway for private subnet
- Route tables and associations
- Security groups for EC2 instances

## Cleanup

To tear down the infrastructure created by Terraform, run:

```bash
terraform destroy

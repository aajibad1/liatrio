# Terraform Execution Readme (AWS)

This document provides step-by-step instructions for setting up and executing Terraform using GitHub Actions with AWS credentials stored as GitHub Secrets. This will allow you to manage AWS infrastructure resources located in the `terraform` folder while keeping your credentials secure.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

1. **GitHub Repository**: Make sure your Terraform code is stored in a GitHub repository.

2. **GitHub Account**: Create a GitHub account if you don't have one already.

3. **AWS Account**: Create an AWS account and gather the AWS access key ID and secret access key.

## GitHub Secrets Setup

To securely manage your AWS credentials, follow these steps to set up GitHub Secrets:

1. **Access AWS Credentials**: Obtain your AWS access key ID and secret access key.

2. **Repository Secrets**:
   - Navigate to your GitHub repository.
   - Click on "Settings" > "Secrets".
   - Click on "New repository secret".
   - Create two secrets: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` and provide their respective values.

## GitHub Actions Workflow

Create a GitHub Actions workflow YAML file to automate the execution of your Terraform code. Here's how:

1. **Create Workflow File**: In your repository, create a `.github/workflows/terraform.yml` file.

2. **Paste the Workflow Configuration**:
   ```yaml
   name: Terraform Automation

   on:
     push:
       branches:
         - master  # Run on changes in the terraform directory

   jobs:
     terraform:
       runs-on: ubuntu-latest

       steps:
       - name: Checkout repository
         uses: actions/checkout@v2

       - name: Set up Terraform
         uses: hashicorp/setup-terraform@v1

       - name: Configure AWS credentials
         env:
           AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
           AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
         run: echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" > ~/.env

       - name: Initialize Terraform
         run: terraform init terraform

       - name: Plan changes
         run: terraform plan -var-file=terraform/terraform.tfvars terraform

       - name: Apply changes
         run: terraform apply -auto-approve -var-file=terraform/terraform.tfvars terraform
   ```

## Workflow Steps

1. **Checkout repository**: This step checks out the repository code.

2. **Set up Terraform**: Installs Terraform on the runner and configures it.

3. **Configure AWS credentials**: Sets the AWS credentials using GitHub Secrets. The credentials are stored in a `.env` file.

4. **Initialize Terraform**: Initializes the Terraform configuration.

5. **Plan changes**: Generates an execution plan.

6. **Apply changes**: Applies the changes to your AWS infrastructure.

## Conclusion

This README guides you through setting up and executing Terraform using GitHub Actions with AWS credentials stored as GitHub Secrets. With this automation, you can manage AWS infrastructure while ensuring the security of your credentials. For more advanced scenarios, consult the [Terraform documentation](https://www.terraform.io/docs/providers/aws/index.html) and GitHub Actions documentation.
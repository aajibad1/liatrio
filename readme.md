# Terraform Execution Readme (AWS)

This document provides step-by-step instructions for executing Terraform with custom variable values to manage AWS infrastructure resources located in the `terraform` folder. It also includes a recommendation to consider using a remote backend for improved state management.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

1. **Terraform**: Install Terraform on your system. You can download it from the official website: [Terraform Downloads](https://www.terraform.io/downloads.html)

2. **AWS Account**: Create an AWS account and configure your AWS credentials with the necessary permissions to create and manage resources.

3. **Access Permissions**: Make sure you have the necessary permissions to create and manage AWS resources.

## Execution Steps

Follow these steps to execute Terraform with custom variable values and manage your AWS infrastructure:

1. **Clone Repository**:
   Clone this repository to your local machine if you haven't already:
   ```sh
   git clone <repository_url>
   ```

2. **Navigate to Terraform Directory**:
   Navigate to the `terraform` folder within the cloned repository:
   ```sh
   cd <path_to_cloned_repository>/terraform
   ```

3. **Initialize Terraform**:
   Initialize Terraform in the directory to download required providers and modules:
   ```sh
   terraform init
   ```

4. **Review and Edit Variable Values**:
   Open the `terraform.tfvars` file and provide appropriate values for your AWS environment. Adjust variables like `AWS_REGION`, `VPC_CIDR_BLOCK`, `CLUSTER_VER`, etc., as needed.

5. **Plan Execution**:
   Generate an execution plan to see what Terraform will do before actually making any changes. Make sure to specify the `-var-file` flag to provide the `terraform.tfvars` file:
   ```sh
   terraform plan -var-file=terraform.tfvars
   ```

6. **Execute Changes**:
   Apply the changes specified in the configuration to create/update AWS resources. Again, include the `-var-file` flag:
   ```sh
   terraform apply -var-file=terraform.tfvars
   ```

   You will be prompted to confirm the changes. Type `yes` and press Enter to proceed.

7. **Destroy Resources (if needed)**:
   If you want to destroy the created resources, you can run:
   ```sh
   terraform destroy -var-file=terraform.tfvars
   ```
   As with `apply`, you will need to confirm the destruction by typing `yes`.

## Recommendation: Use Remote Backend

For improved state management, it's recommended to use a remote backend, such as AWS S3, to store your Terraform state file. To achieve this:

1. Create an S3 bucket to store your Terraform state.
2. Modify your Terraform configuration to use the S3 bucket as a remote backend.
3. Initialize Terraform with the new backend configuration.

Using a remote backend helps with collaboration, state locking, and reduces the risk of losing state in case of local failures.

## Additional Notes

- **State Files**: Even if you're not using a remote backend, ensure you keep the state files (`terraform.tfstate` and `terraform.tfstate.backup`) safe and manage them properly in a team environment.


## Conclusion

This README provides a guide to executing Terraform configurations for AWS infrastructure using custom variable values and includes a recommendation for using a remote backend. For more advanced scenarios, consult the [Terraform documentation](https://www.terraform.io/docs/providers/aws/index.html) and consider best practices for managing infrastructure as code on AWS.
# Deploying Liatrio Infrastructure to AWS EKS with GitHub Actions

This guide will walk you through setting up a GitHub Actions workflow to deploy Liatrio's infrastructure to an AWS EKS cluster using Terraform and Helm.

## Prerequisites

- GitHub repository with the Liatrio codebase.
- AWS Account with necessary permissions to create EKS clusters, IAM roles, and other resources.
- Basic knowledge of GitHub Actions, AWS, Terraform, Helm, and Kubernetes.

## Workflow Overview

1. **GitHub Action Workflow Setup:**
   - The workflow is triggered on a push to the `master` branch.
   - GitHub Actions secrets are not required as IAM roles are used for authentication.
   - The IAM role is assumed by the GitHub Action workflow to gain necessary permissions.
   
2. **Terraform:**
   - Terraform is used to create the EKS cluster, VPC, security groups, and other AWS resources.
   - The IAM role is assumed by the GitHub Action workflow to run Terraform.
   - The `terraform.tfvars` file contains the necessary variables.
   
3. **Docker Build and Push:**
   - A Docker image is built from the `app/` directory and pushed to Amazon ECR.
   
4. **Update Kubernetes Manifests:**
   - The Kubernetes deployment manifest `kubernetes/templates/deployment.yaml` is updated with the ECR image URL.
   
5. **Helm Chart Deployment:**
   - The Helm chart located in the `kubernetes/` directory is deployed using the `helm upgrade --install` command.

6. **Post-Deployment Steps:**
   - Take note of the ECR image URL used in the Kubernetes deployment for future reference.
   
## Getting Started

1. **Fork and Clone the Repository:**
   - Fork the Liatrio repository.
   - Clone the repository using the command:
     ```shell
     git clone git@github.com:aajibad1/liatrio.git
     ```

2. **IAM Role Setup:**
   - Follow the instructions in [this guide](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/) to create an IAM role that GitHub Actions will assume.

3. **Configure GitHub Actions:**
   - Make sure the `.github/workflows/deployment.yaml` file is present in your repository.
   - Update the IAM role ARN in the `deployment.yaml` file:
     ```yaml
     - name: Assume AWS IAM Role
       id: assume-role
       uses: aws-actions/configure-aws-credentials@v3
       with:
         role-to-assume: arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/YOUR_GITHUB_ROLE
         role-session-name: GitHub_to_AWS_via_FederatedOIDC
         aws-region: us-east-1  # Replace with your desired AWS region
     ```
     
4. **Terraform Configuration:**
   - Update `terraform.tfvars` in the `terraform/` directory with your own values.

5. **GitHub Actions Workflow Execution:**
   - Push changes to the `master` branch of your forked repository.
   - GitHub Actions will automatically execute the workflow.

6. **Verify Deployment:**
   - After successful execution, verify the deployment in your EKS cluster.

7. **Update Kubernetes Image URL:**
   - After the Docker image is pushed to ECR, update the `kubernetes/templates/deployment.yaml` file:
     ```yaml
     spec:
       containers:
         - name: liatrio
           image: YOUR_ECR_IMAGE_URL
           ports:
             - containerPort: 5000
     ```
     
8. **Get and Set Kube Context:**
   - To get the available Kubernetes contexts, run:
     ```shell
     kubectl config get-contexts
     ```
   - To set the appropriate context for your EKS cluster, run:
     ```shell
     kubectl config use-context arn:aws:eks:us-east-1:YOUR_AWS_ACCOUNT_ID:cluster/eks-cluster-liatrio-nonprod
     ```
     
9. **Deploy Kubernetes Manifests:**
   - Deploy the Kubernetes manifests using Helm:
     ```shell
     helm upgrade --install liatrio ./kubernetes --namespace liatrio --kube-context arn:aws:eks:us-east-1:YOUR_AWS_ACCOUNT_ID:cluster/eks-cluster-liatrio-nonprod
     ```

## Conclusion

With this setup, you can deploy Liatrio's infrastructure to an AWS EKS cluster using GitHub Actions, Terraform, and Helm. Ensure you have a good understanding of each step before proceeding. For more details, refer to the [official documentation](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html).

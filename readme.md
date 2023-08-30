Certainly, here's the complete README with all the updated changes:

```markdown
# Liatrio Deployment Workflow

This repository contains a GitHub Actions workflow that automates the deployment of an application using Amazon EKS, Terraform, Helm, and Kubernetes.

## Prerequisites

Before getting started, ensure you have the following set up:

1. An AWS account with necessary permissions to create and manage EKS clusters, IAM roles, and EC2 resources.
2. AWS CLI and `kubectl` installed on your local machine.
3. Helm and Terraform installed on your local machine.

## Deployment Workflow

### GitHub Actions Workflow

The deployment workflow in this repository is triggered on pushes to the `master` branch. It follows these steps:

1. Checkout the repository.
2. Set up Terraform and assume the AWS IAM role with necessary permissions.
3. Initialize Terraform and plan the changes.
4. Apply Terraform changes (if the push is on the `master` branch).
5. Capture the EKS cluster's kubeconfig.
6. Capture the ECR image URL.
7. Update the Kubernetes deployment manifest with the ECR image URL.
8. Build and push the Docker image to ECR.
9. Log into Amazon ECR.
10. Tag the Docker image.
11. Push the Docker image to ECR.
12. Use `kubectl` to set the current context and namespace for EKS.
13. Deploy the Helm chart using `helm upgrade --install`.

### Manual Terraform Execution

To run Terraform manually, follow these steps:

1. Navigate to the `terraform` directory:

```bash
cd terraform
```

2. Initialize Terraform:

```bash
terraform init
```

3. Plan the changes:

```bash
terraform plan -var-file=terraform.tfvars
```

4. Apply the changes:

```bash
terraform apply -auto-approve -var-file=terraform.tfvars
```

### GitHub Actions IAM Role Setup

To set up the IAM role for GitHub Actions, follow the guide provided by AWS: [Use IAM Roles to Connect GitHub Actions to Actions in AWS](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/).

Certainly, here's the updated section for the `deployment.yaml` file in the README:

```markdown
# After Successful Deployment

After a successful Terraform deployment, you need to update the `deployment.yaml` file with the ECR image URL that was created during the workflow. This will ensure that your Kubernetes application uses the correct Docker image.

1. Open the `deployment.yaml` file located in the `kubernetes/templates` directory.

2. Locate the `containers` section under `spec` and update the `image` field with the ECR image URL. It should look like this:

```yaml
spec:
  replicas: 1
  selector:
    matchLabels:
      app: liatrio
  template:
    metadata:
      labels:
        app: liatrio
    spec:
      containers:
        - name: liatrio
          image: 218920203343.dkr.ecr.us-east-1.amazonaws.com/liatrio  # Replace with your ECR image URL
          ports:
            - containerPort: 5000
```

3. Save the changes to the `deployment.yaml` file.

4. Open a terminal in the root directory of the cloned repository:

```bash
cd liatrio
```

5. Deploy the updated Helm chart using the following command:
Certainly, here are the instructions on how to manually set up the Kubernetes context and use it for deploying the Helm chart:

```markdown
# Manual Kubernetes Context Setup and Helm Deployment

After a successful Terraform deployment, you can manually set up the Kubernetes context and deploy the Helm chart using the following steps:

1. Open a terminal in your local environment.

2. Use the AWS CLI to update your Kubernetes configuration and set up the context for your EKS cluster. Replace `eks-cluster-liatrio-nonprod` with your actual EKS cluster name and `us-east-1` with your desired AWS region:

```bash
aws eks update-kubeconfig --name eks-cluster-liatrio-nonprod --region us-east-1
```

3. Verify that the context has been set by running:

```bash
kubectl config current-context
```

4. Navigate to the root directory of the cloned repository:

```bash
cd liatrio
```

5. Deploy the Helm chart using the following command:

```bash
helm upgrade --install liatrio ./kubernetes 
```


## Conclusion
```

Please replace `eks-cluster-liatrio-nonprod` and `us-east-1` with the appropriate values for your EKS cluster and AWS region.

## Conclusion

By updating the `deployment.yaml` file with the ECR image URL and redeploying the Helm chart, you ensure that your Kubernetes application is using the correct Docker image. This completes the deployment process and ensures your application is running with the latest changes.
```

Make sure to replace the placeholder in the `image` field with the actual ECR image URL that you captured during the workflow.
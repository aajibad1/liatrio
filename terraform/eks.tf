# EKS Cluster
resource "aws_eks_cluster" "liatrio" {
  name     = "${var.RESOURCE_TAG}-cluster-${var.ENVIRONMENT}"
  role_arn = aws_iam_role.cluster.arn
  version  = var.CLUSTER_VER

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager","scheduler"]

  vpc_config {
    subnet_ids              = flatten([aws_subnet.main-public[*].id, aws_subnet.main-private[*].id])
    endpoint_private_access = true
    endpoint_public_access  = true  # Set this to false to disable public access
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}


# EKS Node Groups
resource "aws_eks_node_group" "liatrio" {
  cluster_name    = aws_eks_cluster.liatrio.name
  node_group_name = var.RESOURCE_TAG
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.main-private[*].id

  scaling_config {
    desired_size = var.DES_SIZE_NODEGROUP
    max_size     = var.MAX_SIZE_NODEGROUP
    min_size     = var.MIN_SIZE_NODEGROUP
  }

  ami_type       = var.AMI_TYPE_NODEGROUP # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
  capacity_type  = var.CAPCITY_TYPE_NODEGROUP  # ON_DEMAND, SPOT
  disk_size      = var.DISK_SIZE_NODEGROUP
  instance_types = [var.INSTANCE_TYPE_NODEGROUP]

tags = {
    "kubernetes.io/cluster/${var.RESOURCE_TAG}-cluster-${var.ENVIRONMENT}" = "owned"
  }

  depends_on = [
    aws_eks_cluster.liatrio,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}

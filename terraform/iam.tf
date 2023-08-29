# EKS Cluster IAM Role
resource "aws_iam_role" "cluster" {
  name = "${var.RESOURCE_TAG}-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# EKS Node IAM Role
resource "aws_iam_role" "node" {
  name = "${var.RESOURCE_TAG}-Worker-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com",
        "AWS": "${aws_iam_role.cluster.arn}"

      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}



resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_Amazonssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_Amazonssm02" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.node.name
}





resource "aws_iam_policy" "alb_ingress_policy" {
  name        = "ALBIngressControllerPolicy"
  description = "Policy for ALB Ingress Controller"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ec2:DescribeSubnets",
          "ec2:CreateLoadBalancer",
          "ec2:CreateTags",
          "ecr:*",
        ],
        Resource = "*",
      },
    ],
  })
}
resource "aws_iam_role_policy_attachment" "alb_ingress_policy_attachment" {
  role      = aws_iam_role.node.name
  policy_arn = aws_iam_policy.alb_ingress_policy.arn
}

resource "aws_iam_role_policy_attachment" "alb_ingress_cluster_policy_attachment" {
  role      = aws_iam_role.cluster.name
  policy_arn = aws_iam_policy.alb_ingress_policy.arn
}


resource "aws_iam_policy" "ecr_policy" {
  name = "ECR-Image-Pull-Policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        Resource = [
          "${aws_ecr_repository.liatrio-ecr.arn}"

        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_ecr_policy" {
  name       = "attach-ecr-policy"
  policy_arn = aws_iam_policy.ecr_policy.arn
  roles      = [aws_iam_role.node.name]
}
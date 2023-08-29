#AWS General Variable Values
AWS_REGION                            = "us-east-1"
AZ_COUNT			                  = "2"
RESOURCE_TAG			              = "eks"
ENVIRONMENT                           = "liatrio-nonprod"


# VPC Variables
VPC_CIDR_BLOCK                        = "10.0.0.0/16"
SUBNET_CIDR_BITS                      = 8
VPC_PUBLIC_SUBNET1_CIDR_BLOCK         = "10.0.1.0/24"
VPC_PUBLIC_SUBNET2_CIDR_BLOCK         = "10.0.2.0/24"
VPC_PUBLIC_SUBNET3_CIDR_BLOCK         = "10.0.3.0/24"
VPC_PRIVATE_SUBNET1_CIDR_BLOCK	      = "10.0.4.0/24"
VPC_PRIVATE_SUBNET2_CIDR_BLOCK	      = "10.0.5.0/24"
VPC_PRIVATE_SUBNET3_CIDR_BLOCK        = "10.0.6.0/24"



#EKS variables
CLUSTER_VER                            = "1.27"
DES_SIZE_NODEGROUP		               = 2
MAX_SIZE_NODEGROUP		               = 5
MIN_SIZE_NODEGROUP		               = 1
AMI_TYPE_NODEGROUP		               = "AL2_x86_64"
CAPCITY_TYPE_NODEGROUP		           = "ON_DEMAND"
DISK_SIZE_NODEGROUP		               = 20
INSTANCE_TYPE_NODEGROUP                = "t2.medium"

#iam variables
#IAMUSER_WPCONT_BUCKET		           = ""
#POLICY_IAMUSER			               = ""


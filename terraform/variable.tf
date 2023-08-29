# aws general variables
variable "AZ_COUNT" {}
variable "AWS_REGION" {}
variable "RESOURCE_TAG" {}
variable "ENVIRONMENT" {}

# VPC variables
variable "VPC_CIDR_BLOCK" {}
variable "SUBNET_CIDR_BITS" {}
variable "VPC_PUBLIC_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PUBLIC_SUBNET2_CIDR_BLOCK" {}
variable "VPC_PUBLIC_SUBNET3_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET1_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET2_CIDR_BLOCK" {}
variable "VPC_PRIVATE_SUBNET3_CIDR_BLOCK" {}

#EKS Variables
variable "CLUSTER_VER" {}
variable "DES_SIZE_NODEGROUP" {}
variable "MAX_SIZE_NODEGROUP" {}
variable "MIN_SIZE_NODEGROUP" {}
variable "AMI_TYPE_NODEGROUP" {}
variable "CAPCITY_TYPE_NODEGROUP" {}
variable "DISK_SIZE_NODEGROUP" {}
variable "INSTANCE_TYPE_NODEGROUP" {}

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.72"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
  # other options for authentication
}



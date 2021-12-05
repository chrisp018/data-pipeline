# --- root/providers.tf ---

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.66.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region                  = "ap-southeast-1" #var.aws_region
  shared_credentials_file = "/Users/khpn/.aws/credentials"
  profile                 = "clphan259-terraform"
}
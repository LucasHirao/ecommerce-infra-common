terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    # State persistido via artifact no workflow CD.
    # Opcional: migrar para backend S3 após primeiro deploy.
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "ecommerce-infra-common"
      Environment = "sandbox"
      ManagedBy   = "terraform"
    }
  }
}

data "aws_caller_identity" "current" {}

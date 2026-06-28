terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "cloud-workload-status-tfstate-240828340986"
    key            = "project1/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "cloud-workload-status-tfstate-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }
  }
}
provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}


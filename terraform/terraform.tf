terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "name-of-your-s3-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 5.0.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }
  }

  required_version = ">= 1.0.0"
}

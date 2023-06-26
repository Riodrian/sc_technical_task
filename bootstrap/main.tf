terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
  }

  required_version = ">=1.0.0"

}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket_prefix = "jokes-app-terraform-state-"
  acl = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
  attribute {
    name = "LockID"
    type = "S"
  }
}

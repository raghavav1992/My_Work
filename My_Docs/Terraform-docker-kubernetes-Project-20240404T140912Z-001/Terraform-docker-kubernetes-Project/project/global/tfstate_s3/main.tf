/*
This script handles:
- Creation of base s3 bucket for terraform states
We need to store the state for this script in github, as we have no s3 bucket for it yet.
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.2" #https://github.com/hashicorp/terraform/releases
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "project-poc-tfstate"
  tags = {
    Name        = "project-tfstate"
    Environment = "poc"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state_access" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

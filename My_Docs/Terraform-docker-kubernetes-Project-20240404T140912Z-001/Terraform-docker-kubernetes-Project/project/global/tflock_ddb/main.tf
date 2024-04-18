/*
This script handles:
- Creation of a dynamo db table to acquire tf state locks for this environment
Attention: This cannot use locking yet!
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "project-poc-tfstate"
    key    = "global/tflock/terraform.tfstate"
    region = "ap-south-1"
  }

  required_version = ">= 1.2" #https://github.com/hashicorp/terraform/releases
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_dynamodb_table" "terraform_locks" {
  # Creates a dynamoDB table to store our tf state locks
  name         = "project-poc-tflock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


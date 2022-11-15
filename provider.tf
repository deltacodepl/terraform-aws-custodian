################################
## AWS Provider Module - Main ##
################################

# AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5"
    }
  }
  
  # backend "s3" {
  #   profile        = "retryjoin"
  #   bucket         = "ccplayground-state"
  #   key            = "custodian/terraform.tfstate"
  #   region         = "eu-central-1"  
  #   dynamodb_table = "custodian-terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region

  default_tags {
    tags = {
      service     = "${lower(var.app_name)}"
      env         =  var.app_environment
      dataclass   = "internal"
      createdby   = "kolszewski"
      costcenter  = "governance"
    }
  }
}


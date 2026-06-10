# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE AN S3 BUCKET TO USE AS A TERRAFORM BACKEND WITH LOCAL LOCKFILE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

terraform {
  required_version = ">= 0.12"
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ------------------------------------------------------------------------------
# CREATE THE S3 BUCKET
# ------------------------------------------------------------------------------

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terraform_state" {
  # Account ID use karne se bucket ka naam poori duniya mein unique ho jata hai
  bucket = "${local.account_id}-terraform-states"

  # Enable versioning taake state files ki history safe rahe
  versioning {
    enabled = true
  }

  # Server-side encryption ko default par enable karna
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# ------------------------------------------------------------------------------
# BACKEND CONFIGURATION
# ------------------------------------------------------------------------------

terraform {
  backend "s3" {
    # ⚠️ NOTE: Is "123456789012" ki jagah apni asli AWS Account ID likhein!
    bucket         = "048679569171-terraform-states" 
    
    key            = "some_environment/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
    # Naye Terraform versions ke liye modern backend locking mechanism
    use_lockfile   = true 
  }
}

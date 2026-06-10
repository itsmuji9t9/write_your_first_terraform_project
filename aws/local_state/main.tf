terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-091138d0f0d41ff90" # Sahi aur fresh Free Tier AMI
  instance_type = "t3.micro"               # Sahi Free Tier instance type

  tags = {
    Name = "Terraform_Demo"
  }
}


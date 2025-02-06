variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

provider "aws" {
  region = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.81.0"
      # region = "eu-west-1"
    }
  }
}
terraform {
  backend "s3" {
    bucket = "eks-bottlerocket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "eks_bottlerocket_terraform_state"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }
  }
}

provider "aws" {
  #profile    = "${var.profile}"
  region     = "${var.region}"    
}
data "aws_availability_zones" "azs" {
    state = "available"
}




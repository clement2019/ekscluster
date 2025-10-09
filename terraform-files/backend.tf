terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 5.0"
      version = "4.0.0"
    }
  }


  backend "s3" {
    bucket         = "bankapp-terraform-eks-state-s3-bucket-11"
    key            = "keys/terraform.tfstate"
    region         = "eu-west-2"
    ##dynamodb_table = "terraform-eks-state-locks"
    ##encrypt        = true
  }
}
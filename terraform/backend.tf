terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 5.0"
      version = "4.0.0"
    }
  }


  backend "s3" {
    bucket         = "jenkins-terraform-aws"
    key            = "terraform-keys/terraform.tfstate"
    region         = "eu-west-2"
    ##dynamodb_table = "terraform-eks-state-locks"
    ##encrypt        = true
  }
}
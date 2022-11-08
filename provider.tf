#######################################################################
#               Set Terraform and Provider Requirements               #
#######################################################################

terraform {
  required_version = "~> 0.12.23"
  backend "s3" {
    bucket         = "github-terraform-example-terraform-state"
    key            = "organization/github-terraform-example/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
  required_providers {
    github = "~> 2.4"
  }
}

provider "github" {
  organization = "yinghan-org"
}

provider "aws" {
  region = "ap-southeast-1"
}


# terraform {
#   required_version = "~> 0.12.9"
#   backend "s3" {
#     bucket         = "github-terraform-example-terraform-state"
#     key            = "organization/github-terraform-example/terraform.tfstate"
#     region         = "ap-southeast-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
#   required_providers {
#     github = "~> 2.9.2"
#     aws    = "~> 3.37"
#   }
# }

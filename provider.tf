#######################################################################
#               Set Terraform and Provider Requirements               #
#######################################################################

# export AWS_ACCESS_KEY_ID=AKIAW3PYPH4IKBKIMUVQ
# export AWS_SECRET_ACCESS_KEY=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
# export GITHUB_OWNER=yinghan-org
# export GITHUB_TOKEN=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
# export GITHUB_TOKEN=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
# export GITHUB_TOKEN=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

terraform {
  required_version = "~> 0.12.9"
  backend "s3" {
    bucket = "github-terraform-example-terraform-state"
    key = "organization/github-terraform-example/terraform.tfstate"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock"
  }
  required_providers {
    github = "~> 2.9.2"
    aws = "~> 3.37"
  }
}

provider "github" {
  organization = "yinghan-org"
}

provider "aws" {
  region = "ap-southeast-1"
}

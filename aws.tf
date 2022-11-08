#######################################################################
#               Create the S3 Bucket and DynamoDB Table               #
#######################################################################

resource "aws_s3_bucket" "terraform_state" {
  bucket = "github-terraform-example-terraform-state-yinghan"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

#######################################################################
#                       Create the IAM policies                       #
#######################################################################

resource "aws_iam_policy" "terraform_s3_list_read_write_policy" {
  name        = "S3TerraformStateListReadWriteAccess"
  path        = "/"
  description = "This policy grants read and write permissions to the Terraform DynamoDB state lock table"
  policy      = data.aws_iam_policy_document.terraform_s3_list_read_write_policy_document.json
}

data "aws_iam_policy_document" "terraform_s3_list_read_write_policy_document" {
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.terraform_state.arn,
      "${aws_s3_bucket.terraform_state.arn}/organization/github-terraform-example/terraform.tfstate"
    ]
  }
}

resource "aws_iam_policy" "terraform_dynamodb_read_write_policy" {
  name        = "DynamoDBTerraformStateLocksReadWriteAccess"
  path        = "/"
  description = "This policy grants read and write permissions to the Terraform DynamoDB state lock table."
  policy      = data.aws_iam_policy_document.terraform_dynamodb_read_write_policy_document.json
}

data "aws_iam_policy_document" "terraform_dynamodb_read_write_policy_document" {
  statement {
    actions = [
      "dynamodb:*"
    ]
    resources = [aws_dynamodb_table.terraform_state_lock.arn]
  }
}

resource "aws_iam_policy" "iam_user_self_management_policy" {
  name        = "IAMUserSelfManagement"
  path        = "/"
  description = "This policy grants an fulls permissions to manage the terraform-ci IAM user and its related IAM policies."
  policy      = data.aws_iam_policy_document.iam_user_self_management_policy_document.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "iam_user_self_management_policy_document" {
  statement {
    actions = [
      "iam:*",
    ]
    resources = [
      aws_iam_user.user.arn,
      aws_iam_policy.terraform_dynamodb_read_write_policy.arn,
      aws_iam_policy.terraform_s3_list_read_write_policy.arn,
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/IAMUserSelfManagement"
    ]
  }
}


#######################################################################
#             Create the IAM user with attached policies              #
#######################################################################

resource "aws_iam_user" "user" {
  name = "terraform-ci"
}

resource "aws_iam_user_policy_attachment" "terraform_s3_list_read_write_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.terraform_s3_list_read_write_policy.arn
}



resource "aws_iam_user_policy_attachment" "terraform_dynamodb_read_write_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.terraform_dynamodb_read_write_policy.arn
}

resource "aws_iam_user_policy_attachment" "iam_user_self_management_policy" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.iam_user_self_management_policy.arn
}

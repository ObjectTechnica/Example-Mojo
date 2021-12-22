data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "stitchfix_key_policy" {
  statement {
    sid       = "Allow access for Key Administrators"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.master_id}:role/MemberAdminRole"]
    }
  }

  statement {
    sid       = "Allow use of the key"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:CreateGrant",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    principals {
      type = "Service"

      identifiers = [
        "rds.amazonaws.com",
        "secretsmanager.amazonaws.com",
        "s3.amazonaws.com",
      ]
    }
  }
}
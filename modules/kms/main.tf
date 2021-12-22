//
// AWS KMS Key for Cloudtrail encrypt_decrypt
//
resource "aws_kms_key" "stitchfix_key" {
  description             = var.kms_description
  key_usage               = var.key_usage
  policy                  = data.aws_iam_policy_document.stitchfix_key_policy.json
  deletion_window_in_days = var.deletion_window_in_days
  is_enabled              = var.is_enabled
  enable_key_rotation     = var.key_rotation

 tags = {
    Description   = "StitchFix-ETL-KMS"
    Environment   = "Infrastructure-Services"
    ManagedBy     = "Terraform"
  }
}

//
// AWS KMS Key Alias
//
resource "aws_kms_alias" "stitchfix_key_alias" {
  name          = "alias/stitchfix-kms-key"
  target_key_id = aws_kms_key.stitchfix_key.id
}
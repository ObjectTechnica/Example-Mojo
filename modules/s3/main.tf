#
# S3 Bucket creation for ETL Data
#
resource "aws_s3_bucket" "etl_bucket" {
  bucket                    = var.bucket_name
  force_destroy             = var.force_destroy
  acl                       = var.s3_acl
  policy                    = data.aws_iam_policy_document.etl_bucket_policy.json

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id   = var.kms_key_id
        sse_algorithm       = "aws:kms"
      }
        bucket_key_enabled   = var.bucket_key
    }
  }
}

resource "aws_s3_bucket_public_access_block" "etl_bucket" {
  bucket                    = aws_s3_bucket.etl_bucket.id
  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true
}
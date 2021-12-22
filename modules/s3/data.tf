data "aws_iam_policy_document" "etl_bucket_policy" {
    statement {
      sid       = "DenySSE-S3"
      effect    = "Deny"
      resources = ["arn:aws:s3:::${var.bucket_name}/*"]
      actions   = ["s3:PutObject"]
  
      condition {
        test     = "StringEquals"
        variable = "s3:x-amz-server-side-encryption"
        values   = ["AES256"]
      }
  
      principals {
        type        = "*"
        identifiers = ["*"]
      }
    }
  
    statement {
      sid       = "RequireKMSEncryption"
      effect    = "Deny"
      resources = ["arn:aws:s3:::${var.bucket_name}/*"]
      actions   = ["s3:PutObject"]
  
      condition {
        test     = "StringNotLikeIfExists"
        variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
        values   = [ "${var.kms_key_id}" ]
      }
  
      principals {
        type        = "*"
        identifiers = ["*"]
      }
    }
  
    statement {
      sid       = "Deny non-approved Access"
      effect    = "Deny"
      resources = ["arn:aws:s3:::${var.bucket_name}/*"]
      actions   = ["s3:*"]
  
      condition {
        test     = "Bool"
        variable = "aws:ViaAWSService"
        values   = ["false"]
      }
  
      condition {
        test     = "StringNotEquals"
        variable = "aws:PrincipalArn"
  
        values = [
          "",
          "arn:aws:iam::${var.master_id}:role/MemberAdminRole",
        ]
      }
  
      principals {
        type        = "*"
        identifiers = ["*"]
      }
    }
  
    statement {
      sid    = "AllowSSLRequestsOnly"
      effect = "Deny"
  
      resources = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*",
      ]
  
      actions = ["s3:*"]
  
      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
  
      principals {
        type        = "*"
        identifiers = ["*"]
      }
    }
  }
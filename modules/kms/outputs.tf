output "kms_key" {
  description = "Output for the KMS key ID"
  value       = aws_kms_key.stitchfix_key.arn
}
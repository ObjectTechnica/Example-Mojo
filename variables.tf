#
# Terraform Provider(s) Variables
#
variable "master_id" {
  description = "The 12-digit account ID used for role assumption"
  default     = "400293920032"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

#
# Prod_ETL VPC Variables
#
variable "prod_vpc_namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "prod-etl"
  type        = string
}

variable "prod_vpc_cidr" {
  description = "cidr for the vpc"
  default     = "10.0.0.0/16" 
}

variable "prod_private_subnets" {
  description = "The list of private subnets by AZ"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "prod_public_subnets" {
  description = "The list of public subnets by AZ"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "prod_database_subnets" {
  description = "The list of public subnets by AZ"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

#
# Hadr_ETL VPC Variables
#
variable "hadr_vpc_namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "hadr-etl"
  type        = string
}

variable "hadr_vpc_cidr" {
  description = "cidr for the vpc"
  default     = "10.10.0.0/16" 
}

variable "hadr_private_subnets" {
  description = "The list of private subnets by AZ"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "hadr_public_subnets" {
  description = "The list of public subnets by AZ"
  type        = list(string)
  default     = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
}

variable "hadr_database_subnets" {
  description = "The list of public subnets by AZ"
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}

#
# Cost Fffective VPC Options - flip to false for testing
#
variable "enable_nat" {
  description = "To deploy or not to deploy a NAT Gateway"
  default     = "true" 
}

#
# Cost Effective NAT Rules - Flip to false for one NAT per AZ for private subnets
#
variable "single_nat" {
  description = "Deploy a single NAT for all private subnets to save money"
  default     = "true" 
}

#
# RDS Variables
#
variable "db_main_allocated_storage" {
  description = "Min amount of storage"
  default     = "100"
}

variable "db_main_max_allocated_storage" {
  description = "Max amount of storage"
  default     = "200" 
}

variable "multi_az" {
  description = "Will this deployment be multi-az"
  default     = "true" 
}

variable "storage_type" {
  description = "The default EBS volume type"
  default     = "gp2" 
}

variable "engine_type" {
  description = "which database will you be running"
  default     = "postgres"
}

variable "engine_version" {
  description = "The major/minor version of the database"
  default     = "13.4" 
}

variable "db_instance_class" {
  description = "the amount of CPU and RAM your db will have"
  default     = "db.t3.micro" 
}

variable "jira_db_admin" {
  description = "the administrative user"
  default     = "jiraadmin" 
}

variable "jira_db_passwd" {
  description = "The admin password"
  default     = "Adminmeplease1!"
}

variable "db_encrypted" {
  description = "Do you want encryption at rest"
  default     = "true" 
}

variable "environment" {
  description = "tagging stuff"
  default     = "Production" 
}

variable "prod_db_namespace" {
  description = "freindly name for RDS"
  default     = "prodetl" 
}

variable "hadr_db_namespace" {
  description = "freindly name for RDS"
  default     = "hadretl" 
}

variable "backup_retention_period" {
  type    = number
  default = 7
}

variable "backup_window" {
  default = "11:27-11:57"
}

#
# KMS Variables
#
variable "kms_description" {
  description = "Unique identifier for this KMS key"
  default     = "Atlassian KMS Key"
}

variable "key_usage" {
  description = "KMS key is either Symectric ot Asymetric"
  default     = "ENCRYPT_DECRYPT" 
}

variable "deletion_window_in_days" {
  description = "Number of days for key deletion"
  default     = "7" 
}

variable "is_enabled" {
  description = "Is this KMS key Enabled or Disabled"
  type        = bool
  default     = "true"
}

variable "key_rotation" {
  description = "Allow KMS to auto rotate the KMS Key"
  type        = bool
  default     = "true" 
}

#
# Secrets Manager Variables
#
variable "pw_length" {
  description = "The total length of the password"
  default     = "24" 
}

variable "pw_special" {
  description = "Include special characters in the result"
  default     = "true" 
}

variable "pw_override" {
  description = "Supply your own list of special characters to use for string generation"
  default     = "_%@"
}

#
# S3 Variables
#
variable "bucket_name" {
  description = "A globally unique bucket name"
  default     = "stitchfix-demo-adam-etl-location"
}

variable "s3_acl" {
  description = "the pre-canned ACL policy you want to apply to your bucket"
  default     = "private" 
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error."
  default     = "true"
}

variable "bucket_key" {
  description = "Whether or not to use Amazon S3 Bucket Keys for SSE-KMS"
  default     = "true" 
}
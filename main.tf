data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

module "prod_vpc" {
  source = "./modules/vpc"
  name                                   = "${var.prod_vpc_namespace}"
  cidr                                   = "${var.prod_vpc_cidr}"
  azs                                    = data.aws_availability_zones.available.names
  private_subnets                        = "${var.prod_private_subnets}"
  public_subnets                         = "${var.prod_public_subnets}"
  database_subnets                       = "${var.prod_database_subnets}"
  enable_nat_gateway                     = "${var.enable_nat}"
  single_nat_gateway                     = "${var.single_nat}"
  enable_dns_hostnames                   = true
  enable_dns_support                     = true
  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group          = true
  default_security_group_ingress         = []
  default_security_group_egress          = []
  # Privatize dedicated DB subnets and routing tables
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                        = true
  create_flow_log_cloudwatch_log_group   = true
  create_flow_log_cloudwatch_iam_role    = true
  flow_log_max_aggregation_interval      = 60
}

module "prod_vpc_endpoints" {
  source = "./modules/vpc-endpoints"

  vpc_id             = module.prod_vpc.vpc_id
  security_group_ids = [ module.prod_vpc.default_security_group_id ]

  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    }
  }  
}

module "hadr_vpc" {
  source = "./modules/vpc"
  name                                   = "${var.hadr_vpc_namespace}"
  cidr                                   = "${var.hadr_vpc_cidr}"
  azs                                    = data.aws_availability_zones.available.names
  private_subnets                        = "${var.hadr_private_subnets}"
  public_subnets                         = "${var.hadr_public_subnets}"
  database_subnets                       = "${var.hadr_database_subnets}"
  enable_nat_gateway                     = "${var.enable_nat}"
  single_nat_gateway                     = "${var.single_nat}"
  enable_dns_hostnames                   = true
  enable_dns_support                     = true
  # Default security group - ingress/egress rules cleared to deny all
  manage_default_security_group          = true
  default_security_group_ingress         = []
  default_security_group_egress          = []
  # Privatize dedicated DB subnets and routing tables
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                        = true
  create_flow_log_cloudwatch_log_group   = true
  create_flow_log_cloudwatch_iam_role    = true
  flow_log_max_aggregation_interval      = 60
}

module "hadr_vpc_endpoints" {
  source = "./modules/vpc-endpoints"

  vpc_id             = module.hadr_vpc.vpc_id
  security_group_ids = [ module.hadr_vpc.default_security_group_id ]

  endpoints = {
    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    }
  }  
}

module "kms" {
  source = "./modules/kms"
  master_id                  = "${var.master_id}"
  kms_description            = "${var.kms_description}" 
  key_usage                  = "${var.key_usage}" 
  deletion_window_in_days    = "${var.deletion_window_in_days}"
  is_enabled                 = "${var.is_enabled}"
  key_rotation               = "${var.key_rotation}"
}

module "etl_s3" {
  source = "./modules/s3"
  depends_on = [
    module.kms
  ]
  bucket_name                = "${var.bucket_name}"
  s3_acl                     = "${var.s3_acl}"
  force_destroy              = "${var.force_destroy}"
  kms_key_id                 = module.kms.kms_key
  bucket_key                 = "${var.bucket_key}" 
  master_id                  = "${var.master_id}"
}

module "peering" {
  source  = "./modules/peering"
  depends_on = [
    module.prod_vpc,
    module.hadr_vpc
 ]
  peer_owner_id           = data.aws_caller_identity.current.account_id
  peering_name            = "Prod_2_Hadr"
  vpc_id                  = module.prod_vpc.vpc_id
  vpc_route_table_id      = module.prod_vpc.database_route_table_ids[0]
  vpc_cidr_block          = "${var.prod_vpc_cidr}"
  peer_vpc_id             = module.hadr_vpc.vpc_id
  peer_vpc_route_table_id = module.hadr_vpc.database_route_table_ids[0]
  peer_vpc_cidr_block     = "${var.hadr_vpc_cidr}"
}

module rds {
  source = "./modules/rds"
    depends_on = [
    module.prod_vpc,
    module.hadr_vpc,
    module.kms,
    module.peering
  ]
  prod_vpc_namespace            = "${var.prod_vpc_namespace}"
  prod_db_namespace             = "${var.prod_db_namespace}"
  prod_vpc_cidr                 = "${var.prod_vpc_cidr}"
  prod_vpc_id                   = module.prod_vpc.vpc_id
  prod_private_subnets          = "${var.prod_private_subnets}"
  prod_database_subnets         = "${var.prod_database_subnets}"
  hadr_db_namespace             = "${var.hadr_db_namespace}"
  hadr_vpc_namespace            = "${var.hadr_vpc_namespace}" 
  hadr_vpc_cidr                 = "${var.hadr_vpc_cidr}"
  hadr_vpc_id                   = module.hadr_vpc.vpc_id
  hadr_private_subnets          = "${var.hadr_private_subnets}"
  hadr_database_subnets         = "${var.hadr_database_subnets}"
  pw_length                     = "${var.pw_length}"
  pw_special                    = "${var.pw_special}"
  pw_override                   = "${var.pw_override}"
  kms_key_id                    = module.kms.kms_key
  db_main_allocated_storage     = "${var.db_main_allocated_storage}"
  db_main_max_allocated_storage = "${var.db_main_max_allocated_storage}"
  backup_retention_period       = "${var.backup_retention_period}"
  backup_window                 = "${var.backup_window}"
  multi_az                      = "${var.multi_az}"
  storage_type                  = "${var.storage_type}"
  engine_type                   = "${var.engine_type}"
  engine_version                = "${var.engine_version}"
  db_instance_class             = "${var.db_instance_class}"
  db_encrypted                  = "${var.db_encrypted}"
  environment                   = "${var.environment}"
}
#
# SG's for Prod/Hadr DB's
#
resource "aws_security_group" "prod_allow_east_west_db" {
  name        = "${var.prod_vpc_namespace}_allow_db"
  description = "Allow db inbound traffic from Private Subnets"
  vpc_id      = var.prod_vpc_id

  ingress {
    description = "DB inbound traffic from Prod Database"
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = "${var.prod_database_subnets}"
  }

  ingress {
    description = "DB inbound traffic from Hadr Database"
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = "${var.hadr_database_subnets}"
  }

egress {
    description = "TCP outbound traffic to Prod Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = "${var.prod_database_subnets}"
  }

egress {
    description = "UDP outbound traffic to Prod Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "UDP"
    cidr_blocks = "${var.prod_database_subnets}"
  }

egress {
    description = "TCP outbound traffic to Hadr Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = "${var.hadr_database_subnets}"
  }

egress {
    description = "Udp outbound traffic to Hadr Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "UDP"
    cidr_blocks = "${var.hadr_database_subnets}"
  }

  tags = {
    Name = "${var.prod_vpc_namespace}-allow_db"
  }
}

resource "aws_security_group" "hadr_allow_east_west_db" {
  name        = "${var.hadr_vpc_namespace}_allow_db"
  description = "Allow db inbound traffic from Private Subnets"
  vpc_id      = var.hadr_vpc_id

  ingress {
    description = "DB inbound traffic from Prod Database"
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = "${var.prod_database_subnets}"
  }

  ingress {
    description = "DB inbound traffic from Hadr Database"
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = "${var.hadr_database_subnets}"
  }

  egress {
    description = "TCP outbound traffic to Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = "${var.prod_database_subnets}"
  }

  egress {
    description = "UDPoutbound traffic to Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "UDP"
    cidr_blocks = "${var.prod_database_subnets}"
  }

  egress {
    description = "TCP outbound traffic to Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "TCP"
    cidr_blocks = "${var.hadr_database_subnets}"
  }

  egress {
    description = "UDP outbound traffic to Database Subnets"
    from_port   = 1024
    to_port     = 65535
    protocol    = "UDP"
    cidr_blocks = "${var.hadr_database_subnets}"
  }

  tags = {
    Name = "${var.hadr_vpc_namespace}-allow_db"
  }
}

#
# Secrets Manager for DB user/pass
#
resource "random_password" "password" {
  length           = var.pw_length
  special          = var.pw_special
  override_special = var.pw_override
}

# Now create secret and secret versions for database master account 
resource "aws_secretsmanager_secret" "etl_db" {
   name                    = "SF_Etl_DB_Creds"
   kms_key_id              = var.kms_key_id
   recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.etl_db.id
  secret_string = <<EOF
   {
    "username": "etladmin",
    "password": "${random_password.password.result}"
   }
EOF
}

# Lets import the Secrets which got created recently and store it so that we can use later. 

data "aws_secretsmanager_secret" "etl_db" {
  arn        = aws_secretsmanager_secret.etl_db.arn
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.etl_db.arn
}

# After Importing the secrets Storing the Imported Secrets into Locals

locals {
  db_creds = jsondecode(
  data.aws_secretsmanager_secret_version.creds.secret_string
   )
}

resource "aws_db_instance" "prod_etl" {
  identifier               = var.prod_vpc_namespace
  allocated_storage        = var.db_main_allocated_storage
  max_allocated_storage    = var.db_main_max_allocated_storage
  backup_retention_period  = var.backup_retention_period
  backup_window            = var.backup_window
  multi_az                 = var.multi_az
  storage_type             = var.storage_type
  engine                   = var.engine_type
  engine_version           = var.engine_version
  instance_class           = var.db_instance_class
  name                     = var.prod_db_namespace
  username                 = local.db_creds.username
  password                 = local.db_creds.password
  storage_encrypted        = var.db_encrypted
  kms_key_id               = var.kms_key_id
  db_subnet_group_name     = var.prod_vpc_namespace
  skip_final_snapshot      = "false"
  vpc_security_group_ids   = [aws_security_group.prod_allow_east_west_db.id]
  tags = {
    environment = var.environment
  }
  final_snapshot_identifier = "jira-${ var.environment }-final"
}

#
# when running a destory the RDS instances will throw errors these are documented issues via Hashicorp
# the "skip_final_snaphot" and the "final_snapshot_identifier" never get read in properly and destroys fail
# https://github.com/hashicorp/terraform/issues/5417 and https://github.com/hashicorp/terraform-provider-aws/issues/2588
# we can add the replica manually, destory the instances manually or skip the replica creation and increate backup retentions on primary
#

resource "aws_db_instance" "hadr_etl" {
  identifier              = var.hadr_vpc_namespace
  allocated_storage       = var.db_main_allocated_storage
  max_allocated_storage   = var.db_main_max_allocated_storage
  multi_az                = var.multi_az
  storage_type            = var.storage_type
  engine                  = var.engine_type
  engine_version          = var.engine_version
  instance_class          = var.db_instance_class
  name                    = var.hadr_db_namespace
  storage_encrypted       = var.db_encrypted
  db_subnet_group_name    = var.hadr_vpc_namespace
  replicate_source_db     = aws_db_instance.prod_etl.arn
  vpc_security_group_ids  = [aws_security_group.hadr_allow_east_west_db.id]
  tags = {
    environment = var.environment
  }
  lifecycle {
    create_before_destroy = true
  }
}

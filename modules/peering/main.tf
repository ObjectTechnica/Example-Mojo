# ---------------------------------------------------------------------------------------------------------------------
# VPC Peering connection between two VPCs within the same account
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc_peering_connection" "this" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = var.peer_vpc_id
  vpc_id        = var.vpc_id
  auto_accept   = var.auto_accept
  accepter {
    allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  }
  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
  tags = {
    Name = var.peering_name
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Create route to peer VPC in first VPC's default route table
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route" "vpc" {
  route_table_id            = var.vpc_route_table_id
  destination_cidr_block    = var.peer_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

# ---------------------------------------------------------------------------------------------------------------------
# Create route to VPC in peer VPC's default route table
# Provider Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_route" "peer_vpc" {
  route_table_id            = var.peer_vpc_route_table_id
  destination_cidr_block    = var.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

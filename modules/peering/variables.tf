# ---------------------------------------------------------------------------------------------------------------------
# Required variables
# ---------------------------------------------------------------------------------------------------------------------

variable "peer_owner_id" {
  description = "The AWS account id the VPC peering will be created in"
  type        = string
}

variable "peer_vpc_id" {
  description = "The second VPC id to peer with"
  type        = string
}

variable "vpc_id" {
  description = "The first VPC id from which to peer"
  type        = string
}

variable "vpc_route_table_id" {
  description = "The route table in the first VPC to add routes to"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The cidr block of the first VPC to add to the route table of the peer VPC"
  type        = string
}

variable "peer_vpc_route_table_id" {
  description = "The route table in the peer VPC to add routes to"
  type        = string
}

variable "peer_vpc_cidr_block" {
  description = "The cidr block of the peer VPC to add to the route table of the first VPC"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# ---------------------------------------------------------------------------------------------------------------------

variable "peering_name" {
  description = "The name tag of the VPC peering connection"
  type        = string
  default     = null
}

variable "auto_accept" {
  description = "Whether the VPC peering connection request should be automatically accepted"
  type        = bool
  default     = true
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  description = "Whether DNS resolution in the accepting VPC is enabled"
  type        = bool
  default     = true
}

variable "requester_allow_remote_vpc_dns_resolution" {
  description = "Whether DNS resolution in the accepting VPC is enabled"
  type        = bool
  default     = true
}

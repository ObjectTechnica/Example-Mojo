output "prod_public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.prod_vpc.public_route_table_ids
}

output "prod_private_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.prod_vpc.private_route_table_ids
}

output "prod_database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = module.prod_vpc.database_route_table_ids
}

output "hadr_public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.hadr_vpc.public_route_table_ids
}

output "hadr_private_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.hadr_vpc.private_route_table_ids
}

output "hadr_database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = module.hadr_vpc.database_route_table_ids
}

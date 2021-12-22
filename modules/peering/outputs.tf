output "vpc_peering_connection" {
  value = aws_vpc_peering_connection.this
}

output "aws_route_vpc" {
  value = aws_route.vpc
}

output "aws_route_peer_vpc" {
  value = aws_route.peer_vpc
}

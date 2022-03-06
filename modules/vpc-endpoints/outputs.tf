################################################################################
# VPC Endpoint(s)
################################################################################

output "vpc_endpoints" {
  description = "Map of VPC Endpoints and their attributes"
  value       = aws_vpc_endpoint.this
}

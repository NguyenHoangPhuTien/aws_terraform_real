output "vpc_id" {
    value = aws_vpc.vpc.id
}
output "subnets_info" {
  value = {for k, v in aws_subnet.subnets: v.id => v.tags.Name}
}
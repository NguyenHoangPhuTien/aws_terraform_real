resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.type == "public" ? var.gateway_id : null
    nat_gateway_id = var.type == "private" ? var.nat_id : null
  }

  tags = (merge(var.tags,
    tomap({
        "Name" : var.name
    })
  ))
}
resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.subnet_info)
  subnet_id      = element(var.subnet_ids, count.index)
  route_table_id = aws_route_table.route_table.id
}


resource "aws_network_acl" "acl" {
  vpc_id = var.vpc_id

  dynamic "egress" {
    for_each = var.acl_info.egress_rules
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_no
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
    }
  }

  dynamic "ingress" {
    for_each = var.acl_info.ingress_rules
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_no
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
    }
  }

  tags = (merge(var.tags,
    tomap({ "Name" : "${var.acl_info.name}" })
  ))
}

resource "aws_network_acl_association" "public_acl_asso" {
  count          = length(var.subnet_info)
  network_acl_id = aws_network_acl.acl.id
  subnet_id      = element(var.subnet_ids, count.index)
}
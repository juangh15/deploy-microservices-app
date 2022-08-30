resource "aws_security_group_rule" "ingress_rule" {
  for_each                 = var.security_ingress_ports
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  security_group_id        = each.value.security_group_id
}

resource "aws_security_group_rule" "egress_rule" {
  for_each                 = var.security_egress_ports
  type                     = "egress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = each.value.protocol
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
  security_group_id        = each.value.security_group_id
}


variable "security_ingress_ports" {
  type = map(object({
    port = number
    protocol = string
    cidr_blocks = list(string)
    security_group_id = string
    source_security_group_id = string
  }))
}

variable "security_egress_ports" {
  type = map(object({
    port = number
    protocol = string
    cidr_blocks = list(string)
    security_group_id = string
    source_security_group_id = string
  }))
}
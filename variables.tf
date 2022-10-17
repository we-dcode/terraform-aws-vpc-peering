variable "this_vpc_id" {
  type = string
}

variable "peer_vpc_id" {
  type = string
}

variable "auto_accept_peering_connection" {
  type = bool
}

variable "allow_this_resolve_dns_in_peer" {
  type    = bool
  default = false
}

variable "allow_peer_resolve_dns_in_this" {
  type    = bool
  default = false
}

variable "this_vpc_route_table_ids" {
  type    = list(string)
  default = []
}

variable "peer_vpc_route_table_ids" {
  type    = list(string)
  default = []
}
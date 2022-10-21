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

variable "target_workaround" {
  description = "This will prepare all required resources without applying routing tables, to workaround the runtime issues."
  type = bool
  default = false
}
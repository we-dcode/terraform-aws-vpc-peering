data "aws_vpc" "this" {
  provider = aws.this
  id       = var.this_vpc_id
}

data "aws_vpc" "peer" {
  provider = aws.peer
  id       = var.peer_vpc_id
}


data "aws_route_tables" "this" {

  provider = aws.this

  count = length(var.this_vpc_route_table_ids) == 0 ? 1 : 0

  vpc_id = data.aws_vpc.this.id
}

locals {
  
  this_vpc_route_table_ids = length(var.this_vpc_route_table_ids) > 0 ? var.this_vpc_route_table_ids : toset(data.aws_route_tables.this[*].id)
  peer_vpc_route_table_ids = length(var.peer_vpc_route_table_ids) > 0 ? var.peer_vpc_route_table_ids : toset(data.aws_route_tables.peer[*].id)
}

resource "aws_route" "peer_routing_from_this" {

  provider = aws.this

  count = length(local.this_vpc_route_table_ids)

  route_table_id            = local.this_vpc_route_table_ids[count.index]
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

data "aws_route_tables" "peer" {

  provider = aws.peer

  count = length(var.peer_vpc_route_table_ids) == 0 ? 1 : 0

  vpc_id = data.aws_vpc.peer.id
}

resource "aws_route" "this_rounting_from_peer" {

  provider = aws.peer

  count = length(local.peer_vpc_route_table_ids)

  route_table_id            = local.peer_vpc_route_table_ids[count.index]
  destination_cidr_block    = data.aws_vpc.this.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

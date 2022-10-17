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
  this_vpc_route_table_ids = length(var.this_vpc_route_table_ids) > 0 ? var.this_vpc_route_table_ids : data.aws_route_tables.this.ids
}

resource "aws_route" "peer_routing_from_this" {

  provider = aws.this

  count = length(local.this_vpc_route_table_ids)

  route_table_id            = local.this_vpc_route_table_ids[count.index]
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

data "aws_route_table" "peer" {

  provider = aws.peer

  vpc_id = var.peer_vpc_id
}


resource "aws_route" "this_rounting_from_peer" {

  provider = aws.peer

  route_table_id            = data.aws_route_table.peer.id
  destination_cidr_block    = data.aws_vpc.this.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

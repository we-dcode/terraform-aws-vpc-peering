# Requester's side of the connection.
resource "aws_vpc_peering_connection" "this" {
  provider = aws.this

  vpc_id        = var.this_vpc_id
  peer_vpc_id   = var.peer_vpc_id
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = data.aws_region.this.name
  #   auto_accept   = false

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = aws.peer

  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = var.auto_accept_peering_connection

  tags = {
    Side = "Accepter"
  }
}

resource "aws_vpc_peering_connection_options" "peer" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  accepter {
    allow_remote_vpc_dns_resolution = var.allow_peer_resolve_dns_in_this
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.peer
  ]

}

resource "aws_vpc_peering_connection_options" "this" {
  provider                  = aws.this
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  requester {
        allow_remote_vpc_dns_resolution = var.allow_this_resolve_dns_in_peer
  }

  depends_on = [
    aws_vpc_peering_connection.this,
    aws_vpc_peering_connection_accepter.peer
  ]

}

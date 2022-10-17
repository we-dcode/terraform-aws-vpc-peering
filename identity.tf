data "aws_caller_identity" "peer" {
  provider = aws.peer
}

data "aws_region" "this" {
  provider = aws.this
}
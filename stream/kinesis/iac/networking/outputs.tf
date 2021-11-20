# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.bigdata_stream_vpc.id
}

output "public_sg" {
  value = aws_security_group.bigdata_stream_sg["public"].id
}

output "public_subnets" {
  value = aws_subnet.bigdata_stream_public_subnet.*.id
}
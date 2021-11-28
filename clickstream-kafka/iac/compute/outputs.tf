# --- compute/outputs.tf ---

output "instance" {
  value = aws_instance.bigdata_stream_node[*].tags["Name"]
  # sensitive = true
}

output "instance_private_ips" {
  # value = {for i in aws_instance.bigdata_stream_node[*]: i.tags["Name"] => i.private_ip }
  value = aws_instance.bigdata_stream_node[*].private_ip
  # sensitive = true
}

output "instance_public_ips" {
  value = { for i in aws_instance.bigdata_stream_node[*] : i.tags["Name"] => i.public_ip }
  # value = aws_instance.bigdata_stream_node[*].private_ip
  # sensitive = true
}
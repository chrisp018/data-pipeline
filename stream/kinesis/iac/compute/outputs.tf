# --- compute/outputs.tf ---

output "instance" {
  value     = aws_instance.bigdata_stream_node[*]
  sensitive = true
}
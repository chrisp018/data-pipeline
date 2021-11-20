# --- visualize/outputs.tf ---

output "elasticsearch_endpoint" {
  value = aws_elasticsearch_domain.elk_stream.endpoint
}
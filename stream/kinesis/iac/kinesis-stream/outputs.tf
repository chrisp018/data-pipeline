# --- kinesis-stream/outputs.tf ---

output "kinesis_stream_id" {
  value = aws_kinesis_stream.kinesis_stream.id
}

output "kinesis_stream_name" {
  value = aws_kinesis_stream.kinesis_stream.name
}
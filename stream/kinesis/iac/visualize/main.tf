# --- visualize/main.tf ---

resource "aws_elasticsearch_domain" "elk_stream" {
  domain_name           = var.elasticsearch_name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_type = var.elasticsearch_instance_type
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.elasticsearch_ebs_size
  }

  tags = {
    Domain = var.elasticsearch_name
  }
}

resource "aws_elasticsearch_domain_policy" "elk_stream_policy" {
  domain_name = aws_elasticsearch_domain.elk_stream.domain_name

  access_policies = <<POLICIES
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {"aws:SourceIp": "171.232.85.49/32"}
            },
            "Resource": "${aws_elasticsearch_domain.elk_stream.arn}/*"
        }
    ]
}
POLICIES
}
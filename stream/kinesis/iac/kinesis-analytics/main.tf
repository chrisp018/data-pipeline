# --- kinesis-analytics/main.tf ---

resource "aws_s3_bucket_object" "s3_flink_app" {
  bucket = var.analytic_s3_name
  key    = var.analytic_s3_key
  source = var.analytic_flink_source
}

resource "aws_kinesisanalyticsv2_application" "kinesis_analytic" {
  name                   = var.analytic_name
  runtime_environment    = var.flink_version
  service_execution_role = var.analytic_iam_role_arn

  application_configuration {
    application_code_configuration {
      code_content {
        s3_content_location {
          bucket_arn = var.analytic_s3_arn
          file_key   = aws_s3_bucket_object.s3_flink_app.key
        }
      }

      code_content_type = var.content_type
    }
    environment_properties {
      property_group {
        property_group_id = var.analytic_env_group_id
        property_map      = var.analytic_env_map
      }
    }
    flink_application_configuration {
      checkpoint_configuration {
        configuration_type = "DEFAULT"
      }

      monitoring_configuration {
        configuration_type = "CUSTOM"
        log_level          = "DEBUG"
        metrics_level      = "TASK"
      }
      parallelism_configuration {
        auto_scaling_enabled = true
        configuration_type   = "DEFAULT"
        parallelism          = 1
        parallelism_per_kpu  = 1
      }
    }
  }
  tags = {
    Environment = var.analytic_name
  }
}
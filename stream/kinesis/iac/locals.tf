locals {
  vpc_cidr     = "10.0.0.0/16"
  project_name = var.project_name
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}

locals {
  iam_role = {
    instance_role = {
      name        = "${local.project_name}-instance_access_role"
      policy_name = ["instance_access_s3", "instance_access_kinesis_stream"]
      assume_role_policy = jsonencode({
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
              Service = "ec2.amazonaws.com"
            }
          },
        ]
      })
    }
  }
}

locals {
  iam_policy = {
    instance_access_s3 = {
      name = "${local.project_name}-instance_access_s3"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "s3:ListBucket"
            ]
            Effect   = "Allow"
            Resource = "*"
          },
          {
            Action = [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
            ]
            Effect   = "Allow"
            Resource = "*"
          }
        ]
      })
    }
    instance_access_kinesis_stream = {
      name = "${local.project_name}-instance_access_kinesis_stream"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = [
              "kinesis:*"
            ]
            Effect   = "Allow"
            Resource = "*"
          }
        ]
      })
    }
  }
}
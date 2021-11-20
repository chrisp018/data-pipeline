# --- root/variables.tf ---

variable "project_name" {
  type    = string
  default = "bigdata-stream"
}
variable "home_path" {}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "access_ip" {}

# S3 bucket location 
variable "bigdata_stream_bucket" {}
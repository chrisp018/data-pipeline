# --- root/main.tf ---

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  private_sn_count = 2
  public_sn_count  = 2
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  max_subnets      = 20
  security_groups  = local.security_groups
}

module "compute" {
  source             = "./compute"
  public_sg          = module.networking.public_sg
  public_subnets     = module.networking.public_subnets
  profile_name       = "${local.iam_role.instance_role.name}_profile"
  instance_role_name = local.iam_role.instance_role.name
  instance_count     = 1
  instance_type      = "t2.micro"
  vol_size           = "10"
  public_key_path    = "${var.home_path}.ssh/bigdata_stream.pub"
  private_key_path   = "${var.home_path}.ssh/bigdata_stream"
  key_name           = "bigdata_stream"
  user_data_path     = "${path.root}/data-replay.tpl"
  data_replay_exec   = "${path.root}/data-replay-exec.sh"
  stream_data_source = "${path.root}/stream-resources/amazon-kinesis-replay-0.1.0.jar"
}

module "security" {
  source     = "./security"
  iam_role   = local.iam_role
  iam_policy = local.iam_policy
}

module "visualize" {
  source                      = "./visualize"
  elasticsearch_name          = "bigdata-visualize-stream"
  elasticsearch_version       = "7.10"
  elasticsearch_instance_type = "t3.medium.elasticsearch"
  elasticsearch_ebs_size      = 10
}

module "stream_s3_source" {
  source      = "./storage"
  bucket_name = local.stream_s3_source_name
}

module "ingession_layer" {
  source = "./kinesis-stream"

  kinesis_stream_name = "bigdata_ingression_stream"
  shard_count         = 1
  retention_period    = 24
  shard_level_metrics = ["IncomingBytes", "OutgoingBytes"]
}

module "processing-layer" {
  source = "./kinesis-analytics"

  analytic_flink_source = "${path.root}/stream-resources/amazon-kinesis-analytics-taxi-consumer-0.2.1.jar"
  analytic_name         = "bigdata-stream-analytic"
  flink_version         = "FLINK-1_11"
  analytic_iam_role_arn = module.security.iam_role_out[local.iam_role.kinesis_analytic_role.name]
  analytic_s3_arn       = module.stream_s3_source.bucket_arn
  analytic_s3_name      = local.stream_s3_source_name
  analytic_s3_key       = "flink-application"
  content_type          = "ZIPFILE"
  analytic_env_group_id = "FlinkApplicationProperties"
  analytic_env_map      = tomap({ InputStreamName = "bigdata_ingression_stream", ElasticsearchEndpoint = "https://${module.visualize.elasticsearch_endpoint}" })
}
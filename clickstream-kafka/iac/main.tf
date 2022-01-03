# --- root/main.tf ---

resource "aws_key_pair" "bigdata_stream_auth" {
  key_name   = "ths_bigdata_stream"
  public_key = file("${var.home_path}.ssh/ths_bigdata_stream.pub")
}

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  private_sn_count = 3
  public_sn_count  = 3
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  max_subnets      = 20
  security_groups  = local.security_groups
}

module "zookeeper" {
  source                  = "./compute"
  resource_group_name     = "zkp"
  public_sg               = module.networking.public_sg
  public_subnets          = module.networking.public_subnets
  profile_name            = "${local.iam_role.instance_role.name}_profile"
  instance_role_name      = local.iam_role.instance_role.name
  instance_count          = 3
  instance_type           = "t2.micro"
  vol_size                = "10"
  public_key_path         = "${var.home_path}.ssh/ths_bigdata_stream.pub"
  private_key_path        = "${var.home_path}.ssh/ths_bigdata_stream"
  key_name                = aws_key_pair.bigdata_stream_auth.id
  user_data_path          = "${path.root}/mgmt/zkp_config/zkp_install.tpl"
  provisioner_file_source = "${path.root}/mgmt/zkp_config"
  provisioner_file_dest   = "/home/ubuntu/mgmt"
  # remote_exec = {}
  local_exec_var = "zookeeper"
}

module "zkp_kafka_monitoring" {
  source                  = "./compute"
  resource_group_name     = "zkp-kafka-mntr"
  public_sg               = module.networking.public_sg
  public_subnets          = module.networking.public_subnets
  profile_name            = "${local.iam_role.instance_role.name}_profile_zkp_kafka_mntr"
  instance_role_name      = local.iam_role.instance_role.name
  instance_count          = 1
  instance_type           = "t3.medium"
  vol_size                = "10"
  public_key_path         = "${var.home_path}.ssh/ths_bigdata_stream.pub"
  private_key_path        = "${var.home_path}.ssh/ths_bigdata_stream"
  key_name                = "ths_bigdata_stream"
  user_data_path          = "${path.root}/mgmt/mntr_config/tools.tpl"
  provisioner_file_source = "${path.root}/mgmt/mntr_config"
  provisioner_file_dest   = "/home/ubuntu/mgmt"
  local_exec_var          = "zookeeper_mntr"
  # remote_exec = {}
}

module "kafka" {
  source                  = "./compute"
  resource_group_name     = "kafka"
  public_sg               = module.networking.public_sg
  public_subnets          = module.networking.public_subnets
  profile_name            = "${local.iam_role.instance_role.name}_profile_kafka"
  instance_role_name      = local.iam_role.instance_role.name
  instance_count          = 1
  instance_type           = "t3.medium"
  vol_size                = "10"
  public_key_path         = "${var.home_path}.ssh/ths_bigdata_stream.pub"
  private_key_path        = "${var.home_path}.ssh/ths_bigdata_stream"
  key_name                = "ths_bigdata_stream"
  user_data_path          = "${path.root}/mgmt/kafka_config/kafka_install.tpl"
  provisioner_file_source = "${path.root}/mgmt/kafka_config"
  provisioner_file_dest   = "/home/ubuntu/mgmt"
  local_exec_var          = "kafka"
  # remote_exec = {}
}

# module "ksql" {
#   source                  = "./compute"
#   resource_group_name     = "ksql"
#   public_sg               = module.networking.public_sg
#   public_subnets          = module.networking.public_subnets
#   profile_name            = "${local.iam_role.instance_role.name}_ksql"
#   instance_role_name      = local.iam_role.instance_role.name
#   instance_count          = 1
#   instance_type           = "t3.medium"
#   vol_size                = "10"
#   public_key_path         = "${var.home_path}.ssh/ths_bigdata_stream.pub"
#   private_key_path        = "${var.home_path}.ssh/ths_bigdata_stream"
#   key_name                = "ths_bigdata_stream"
#   user_data_path          = "${path.root}/mgmt/mntr_config/tools.tpl"
#   provisioner_file_source = "${path.root}/mgmt/mntr_config"
#   provisioner_file_dest   = "/home/ubuntu/mgmt"
#   local_exec_var          = "zookeeper_mntr"
#   # remote_exec = {}
# }

module "security" {
  source     = "./security"
  iam_role   = local.iam_role
  iam_policy = local.iam_policy
}

# module "visualize" {
#   source                      = "./visualize"
#   elasticsearch_name          = "bigdata-visualize-data"
#   elasticsearch_version       = "7.1"
#   elasticsearch_instance_type = "t3.medium.elasticsearch"
#   elasticsearch_ebs_size      = 10
# }

# module "stream_s3_source" {
#   source      = "./storage"
#   bucket_name = local.stream_s3_source_name
# }
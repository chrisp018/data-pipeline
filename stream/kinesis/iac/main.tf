# --- root/main.tf ---

module "ingession_layer" {
  source = "./kinesis-stream"

  kinesis_stream_name = "bigdata_ingression_stream"
  shard_count         = 1
  retention_period    = 24
  shard_level_metrics = ["IncomingBytes", "OutgoingBytes"]
}

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
  private_key_path = "${var.home_path}.ssh/bigdata_stream"
  key_name           = "bigdata_stream"
  user_data_path     = "${path.root}/data-replay.tpl"
  data_replay_exec   = "${path.root}/data-replay-exec.sh"
}

module "security" {
  source     = "./security"
  iam_role   = local.iam_role
  iam_policy = local.iam_policy
}
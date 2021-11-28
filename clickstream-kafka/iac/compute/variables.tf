# --- compute/variables.tf ---

variable "instance_count" {}
variable "instance_type" {}
variable "public_sg" {}
variable "public_subnets" {}
variable "vol_size" {}
variable "public_key_path" {}
variable "private_key_path" {}
variable "key_name" {}
variable "user_data_path" {}
# variable "user_data_args" {}
variable "profile_name" {}
variable "instance_role_name" {}
variable "resource_group_name" {}

variable "provisioner_file_source" {}
variable "provisioner_file_dest" {}
# variable "remote_exec" {}
variable "local_exec_var" {}
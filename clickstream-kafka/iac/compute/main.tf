# --- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "bigdata_stream_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_instance" "bigdata_stream_node" {
  count                = var.instance_count
  instance_type        = var.instance_type
  ami                  = data.aws_ami.server_ami.id
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "bigdata_stream_node-${var.resource_group_name}-${random_id.bigdata_stream_node_id[count.index].dec}"
  }

  key_name               = var.key_name
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  user_data = templatefile(var.user_data_path, {
    HOME_PATH = "/home/ubuntu",
    USER      = "ubuntu",
    MYID      = count.index + 1
  })
  root_block_device {
    volume_size = var.vol_size
  }

  provisioner "local-exec" {
    command = "sed 's/<broker_id>/${count.index + 1}/g' ${path.root}/mgmt/kafka_config/server_default.properties > ${path.root}/mgmt/kafka_config/server.properties"
  }

  provisioner "file" {
    source      = var.provisioner_file_source
    destination = var.provisioner_file_dest
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.private_key_path)
    }
  }

  # provisioner "remote-exec" {
  #   inline = var.remote_exec
  # }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} ${var.local_exec_var}${count.index + 1} >> ${path.root}/mgmt/private_ips.txt"
  }
  
  provisioner "remote-exec" {
    inline = ["sudo hostnamectl set-hostname bigdata-stream-node-${var.resource_group_name}-${random_id.bigdata_stream_node_id[count.index].dec}"]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      private_key = file(var.private_key_path)
    }
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.profile_name
  role = var.instance_role_name
}

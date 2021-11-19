# --- compute/main.tf ---

data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

resource "random_id" "bigdata_stream_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "bigdata_stream_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "bigdata_stream_node" {
  count                = var.instance_count
  instance_type        = var.instance_type
  ami                  = data.aws_ami.server_ami.id
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  tags = {
    Name = "bigdata_stream_node-${random_id.bigdata_stream_node_id[count.index].dec}"
  }

  key_name               = aws_key_pair.bigdata_stream_auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  user_data = templatefile(var.user_data_path,
    {
      nodename = "bigdata_stream-${random_id.bigdata_stream_node_id[count.index].dec}"
    }
  )
  root_block_device {
    volume_size = var.vol_size
  }

  provisioner "file" {
    source      = var.data_replay_exec
    destination = "/home/ec2-user/data-replay-exec.sh"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file(var.private_key_path)
    }
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.profile_name
  role = var.instance_role_name
}

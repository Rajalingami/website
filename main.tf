terraform {

  backend "local" {
    path          = "./terraform.tfstate"
    workspace_dir = "."
  }
  /*
cloud {
    organization = "mycute"

    workspaces {
      name = "website"
    }
  }
*/
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }

  required_version = ">= 1.10.5"
}

provider "aws" {
  region = var.region

}

// added comments for the aws_instance
resource "aws_instance" "instance" {
  ami           = "ami-08b5b3a93ed654d19"
  instance_type = var.instance_type
  //  security_groups = [ "aws_security_group.sg_grp" ]
  vpc_security_group_ids      = [aws_security_group.sg_grp.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key.key_name
  user_data                   = <<-EOF
        #!/bin/bash
        sudo yum update -y
        sudo yum install -y httpd
        sudo systemctl start httpd
        sudo chkconfig httpd on
        sudo echo "<HTML><H1> Welcome to the Terraform server - RAJA </H1></HTML>" > /var/www/html/index.html
    EOF

  depends_on = [aws_security_group.sg_grp]
}

resource "aws_key_pair" "key" {
  key_name = "my-key-pair"
  //    public_key = tls_private_key.pkey.public_key_openssh

  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/FPqz/Pt4vUKZ4A5j2pC6ANnZDF4cPtS/zhYcCf01mLXlq/GF/3EkR7NQZV7+TMgIYUu79WVCJHh+IvtWbbMRCPcayvdDZqKSbHe8/blwMxbVYpUUGGF9OE6aBnfy5a+QDGjRZJ+x3PHkkmzqiKj7XsUGxLCCf6NIZopDtBeHGsZAgzJMOY8fpt+vgafeV+vmh95oxt2BEmkU3sOy1LsuCU7JH9NPu68HJAJBHc5XAKa9adPhJaUOe+3VMg6Y4KHsGOq8aUm7attpItwA1XMVk32fXNXsyxZz+e9wv2k34PvBVfGSx6G0i3fE8OJqhxgk7PeXYzIKAW8AljH+z8L7 root@LAPTOP-TTD3SHQT"
}

resource "tls_private_key" "pkey" {
  rsa_bits  = 2048
  algorithm = "RSA"

}

resource "aws_security_group" "sg_grp" {
  description = "new security group"
  name        = "web-security-group"
  vpc_id      = "vpc-08de1bb98fc34b72d"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
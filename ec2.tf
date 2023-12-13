module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix = "${var.project}-eks-ssh-key"
  public_key      = ""

  tags = {
    Name        = "${var.project}-eks-ssh-key"
    Environment = "dev"
  }
}

resource "aws_security_group" "remote_access" {
  name_prefix = "${var.project}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.project}-eks-ssh-access"
    Environment = "dev"
  }
}
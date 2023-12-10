
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${var.project}-cluster"
  cluster_version = "1.28"

  cluster_endpoint_public_access  = false

  cluster_addons = {
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = true
      resolve_conflicts_on_update = true

    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = true
      resolve_conflicts_on_update = true
    }
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = true
      resolve_conflicts_on_update = true
    }
  }

  vpc_id                   = module.vpc.vpc_id 
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t2.micro", "t2.small"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 1
      desired_size = 1

      instance_types = ["t2.small"]
      capacity_type  = "SPOT"

      use_custom_launch_template = false
      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"
      bootstrap_extra_args = <<-EOT
        # extra args added
        [settings.kernel]
        lockdown = "integrity"
      EOT
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "${aws_iam_role.cluster_role.arn}"
      username = "${aws_iam_role.cluster_role.arn}"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${var.aws_account}:user/${var.aws_user}"
      username = "${var.aws_account}"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "${var.aws_account}",
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
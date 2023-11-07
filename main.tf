module "vpc" {
  source = "./module/vpc"

  vpc_cidr = "10.0.0.0/16"
  public_subnets = {
    "subnet_a1" = {
      cidr = "10.0.10.0/24",
      az   = "ap-northeast-2a",
      tags = {
        Name = "public subnet a1"
      }
    },
    "subnet_b1" = {
      cidr = "10.0.11.0/24",
      az   = "ap-northeast-2c",
      tags = {
        Name = "public subnet c1"
      }
    }
  }
  private_subnets = {
    "subnet_a1" = {
      cidr = "10.0.100.0/24",
      az   = "ap-northeast-2a",
      tags = {
        Name = "private subnet a1"
      }
    },
    "subnet_b1" = {
      cidr = "10.0.101.0/24",
      az   = "ap-northeast-2c",
      tags = {
        Name = "private subnet c1"
      }
    }
  }
}

module "eks" {
  source = "./module/eks"

  eks-name                = "eks-from-terraform"
  eks_version             = "1.27"
  vpc_id                  = module.vpc.vpc_id
  private_subnets_ids     = module.vpc.private_subnets_ids
  endpoint_prviate_access = true
  endpoint_public_access  = true
  managed_node_groups = {
    "managed-node-group-a" = {
      node_group_name = "managed-node-group",
      instance_types  = ["t3a.medium"],
      capacity_type   = "ON_DEMAND",
      release_version = "" #latest
      disk_size       = 20
      desired_size    = 2,
      max_size        = 5,
      min_size        = 1
    }
  }
  aws_auth_admin_roles = ["arn:aws:iam::776665911703:role/eks-admin-role"]
}


## 별도 모듈화 필요
/*
module "add-on" {
  source = "./module/add-on"

  alb-name            = "eks-external-alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets_ids  = module.vpc.public_subnets_ids
}
*/

/*
module "lb_role" {
  source = "./module/terraform-aws-iam/modules/iam-role-for-service-accounts-eks"
  #role_name                              = "${var.env_name}_eks_lb"
  role_name                              = "aws-gateway-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
     main = {
     # 별도 상속 필요 
     #provider_arn               = module.eks.oidc_provider_arn
     provider_arn               = "arn:aws:iam::776665911703:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/1B67660AF7A0E3CE8628CAF1587CE78"
     namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
     }
 }
 }

resource "kubernetes_service_account" "service-account" {
  metadata {
     name      = "aws-load-balancer-controller"
     namespace = "kube-system"
     labels = {
     "app.kubernetes.io/name"      = "aws-load-balancer-controller"
     "app.kubernetes.io/component" = "controller"
     }
     annotations = {
     "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
     #"eks.amazonaws.com/role-arn"                = "arn:aws:iam::776665911703:role/aws-gateway-controller"
     "eks.amazonaws.com/sts-regional-endpoints" = "true"
     }
 }
 }
*/

# resource "helm_release" "alb-controller" {
#  name       = "aws-load-balancer-controller"
#  repository = "https://aws.github.io/eks-charts"
#  chart      = "aws-load-balancer-controller"
#  namespace  = "kube-system"
#  depends_on = [
#      kubernetes_service_account.service-account
#  ]

#  set {
#      name  = "region"
#      value = "ap-northeast-2"
#  }

#  set {
#      name  = "vpcId"
#      value = module.vpc.vpc_id
#  }

#  set {
#      name  = "image.repository"
#      value = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
#  }

#  set {
#      name  = "serviceAccount.create"
#      value = "false"
#  }

#  set {
#      name  = "serviceAccount.name"
#      value = "aws-load-balancer-controller"
#  }

#  set {
#      name  = "clusterName"
#      value = "eks-from-terraform"
#  }
#  }
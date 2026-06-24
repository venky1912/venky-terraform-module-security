module "security" {
  source = "../../"

  name = "platform-dev"

  kms_keys = {
    eks = {
      description         = "EKS cluster encryption"
      enable_key_rotation = true
    }
    rds = {
      description             = "RDS encryption"
      deletion_window_in_days = 7
      enable_key_rotation     = true
    }
  }

  security_groups = {
    eks-cluster = {
      vpc_id      = "vpc-12345678"
      description = "EKS cluster control plane"
      ingress_rules = {
        https = {
          description = "Allow HTTPS from VPC"
          from_port   = 443
          to_port     = 443
          ip_protocol = "tcp"
          cidr_ipv4   = "10.0.0.0/16"
        }
      }
      egress_rules = {
        all = {
          description = "Allow all egress"
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "eks-platform"
    ManagedBy   = "terraform"
  }
}

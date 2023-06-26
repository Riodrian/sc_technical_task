resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.GITHUB_THUMBPRINTS
  url             = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "oidc_cluster_role" {
  name = "oidc-cluster-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "eks:DescribeCluster"
          ],
          "Resource": "arn:aws:eks:*:*:cluster/*"
        }
      ]
    }
  EOF
}

resource "aws_iam_role_policy" "github_oidc_eks_policy" {
    name = "github-oidc-eks-policy"
    role = aws_iam_role.github_oidc_auth_role.id

    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "DescribeCluster"
        Action = [
          "eks:DescribeCluster",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:eks:*:*:cluster/*"
      },
      {
        Sid      = "ListClusters"
        Action = [
          "eks:ListClusters",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
    })
}

resource "kubernetes_cluster_role" "github_oidc_cluster_role" {
    metadata {
        name = "github-oidc-cluster-role"
    }

    rule {
        api_groups  = ["*"]
        resources   = ["deployments","pods","services"]
        verbs       = ["get", "list", "watch", "create", "update", "patch", "delete"]
    }
}

resource "kubernetes_cluster_role_binding" "github_oidc_cluster_role_binding" {
  metadata {
    name = "github-oidc-cluster-role-binding"
  }

  subject {
    kind = "User"
    name =  "github-oidc-auth-user"
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.github_oidc_cluster_role.metadata[0].name
  }
}

resource "aws_iam_role" "github_oidc_auth_role" {
  assume_role_policy = data.aws_iam_policy_document.github_assume_role_policy.json
  name               = "github-oidc-auth-role"
}

resource "kubernetes_secret" "eks_credentials" {
  metadata {
    name = "eks-credentials"
    namespace = "default"
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "ghcr.io" = {
          "username" = jsondecode(data.aws_secretsmanager_secret_version.github_container_registry.secret_string)["username"]
          "password" = jsondecode(data.aws_secretsmanager_secret_version.github_container_registry.secret_string)["password"]
          "email"    = jsondecode(data.aws_secretsmanager_secret_version.github_container_registry.secret_string)["email"]
          "auth"     = base64encode("${jsondecode(data.aws_secretsmanager_secret_version.github_container_registry.secret_string)["username"]}:${jsondecode(data.aws_secretsmanager_secret_version.github_container_registry.secret_string)["password"]}")
        }
      }
    })
  }
}

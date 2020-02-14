#
#  EKS Cluster
#  * The KMS key for EKS Log Group 
#  * The CloudWatch Log Group for EKS Cluster
#  * The configuration of EKS Cluster
#

resource "aws_kms_key" "eks_log_group" {
  description             = "KMS key for EKS Log Group"
  deletion_window_in_days = 7

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Id" : "key-default-1",
  "Statement" : [ {
      "Sid" : "Enable IAM User Permissions",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "logs.${data.aws_region.current.id}.amazonaws.com" },
      "Action": [ 
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*"
    }  
  ]
}
EOF

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )

}


resource "aws_cloudwatch_log_group" "eks" {
  name              	= "/aws/eks/${aws_eks_cluster.cluster.name}/cluster"
  retention_in_days 	= var.cluster_log_retention_in_days
  kms_key_id        	= aws_kms_key.eks_log_group.arn

  tags = map(
    "Name", "eks-${var.projectname}-${var.environment}",
    "Environment", "${var.environment}",
    "Terraformed", "true",
    "kubernetes.io/cluster/cluster-${var.projectname}-${var.environment}", "shared",
  )
}

resource "aws_eks_cluster" "cluster" {
  name     			= "cluster-${var.projectname}-${var.environment}"
  role_arn 			= aws_iam_role.cluster.arn
  version      			= var.k8s_version
    
  vpc_config {
    security_group_ids 		= [aws_security_group.cluster.id]
    subnet_ids         		= var.subnet_private_id
    endpoint_private_access 	= true 
    endpoint_public_access	= true
    public_access_cidrs       	= ["0.0.0.0/0"]
  }

//  enabled_cluster_log_types 	= var.cluster_enabled_log_types

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster-AmazonEKSServicePolicy,
//    aws_cloudwatch_log_group.eks
  ]
}

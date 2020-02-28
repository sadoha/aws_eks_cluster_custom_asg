variable "projectname" {}

variable "environment" {}

variable "countindex" {}

variable "vpc_id" {}

variable "subnet_private_id" {}

variable "key_pair" {}

# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

#
# Workstation External IP
#
# This configuration is not required and is
# only provided as an example to easily fetch
# the external IP of your local workstation to
# configure inbound EC2 Security Group access
# to the Kubernetes cluster.
#

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

# Override with variable or hardcoded value if necessary
locals {
  workstation-external-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

#
# EKS Cluster
#

variable "k8s_version" {
  default     = "1.14"
  type        = string
  description = "Required K8s version"
}

variable "kublet_extra_args" {
  default     = ""
  type        = string
  description = "Additional arguments to supply to the node kubelet process"
}

variable "cluster_log_retention_in_days" {
  default     = 30
  type        = number
  description = "Number of days to retain log events. Default retention - 90 days."
}

variable "cluster_enabled_log_types" {
  default     = ["api", "audit"]
  description = "A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}

variable "cluster_create_timeout" {
  description = "Timeout value when creating the EKS cluster."
  type        = string
  default     = "15m"
}

variable "cluster_delete_timeout" {
  description = "Timeout value when deleting the EKS cluster."
  type        = string
  default     = "15m"
}

#
# EKS Worker Nodes Resources
#

variable "instance_types" {
  type          = string
  default       = "t3.large"
  description   = "The instance types of a EKS cluster"
}

variable "volume_size" {
  type          = string
  default       = "30"
  description   = "The volume size of a EKS nodes"
}

variable "volume_type" {
  type          = string
  default       = "standard"
  description   = "The volume type of a EKS nodes"
}

variable "iops" {
  type          = string
  default       = "0"
  description   = "The volume iops of a EKS nodes"
}

data "aws_ami" "eks_worker_ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.k8s_version}-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}

#
# Outputs
#

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "autoscaling_groups_name" {
  value = aws_autoscaling_group.eks.name
}

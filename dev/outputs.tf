#
# Outputs
#

### AWS EKS

output "kubeconfig" {
  value       = module.eks.kubeconfig
  description = "EKS Kubeconfig"
}

//output "config-map" {
//  value       = module.eks.config_map_aws_auth
//  description = "K8S config map to authorize"
//}


### AWS Route 53

//output "route53_zone_name" {
//  value = "${module.r53.zone_name}"
//}

//output "route53_ns" {
//  value = "${module.r53.ns}"
//}

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.nodes.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes

CONFIGMAPAWSAUTH
### 
### ATTENCION !!!!
###
### If worker nodes was not been attached:
###
### Uncomment and run terraform output config_map_aws_auth 
### Save the configuration into a file, e.g. config_map_aws_auth.yaml
### Run kubectl apply -f config_map_aws_auth.yaml
### You can verify the worker nodes are joining the cluster via: kubectl get nodes --watch


  kubeconfig = <<KUBECONFIG

apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.cluster.endpoint}
    certificate-authority-data: ${aws_eks_cluster.cluster.certificate_authority.0.data}
  name: ${aws_eks_cluster.cluster.name} 
contexts:
- context:
    cluster: ${aws_eks_cluster.cluster.name}
    user: ${aws_eks_cluster.cluster.name}
  name: ${aws_eks_cluster.cluster.name}
current-context: ${aws_eks_cluster.cluster.name}
kind: Config
preferences: {}
users:
- name: ${aws_eks_cluster.cluster.name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${aws_eks_cluster.cluster.name}"

KUBECONFIG
}


resource "local_file" "kubeconfig" {
    content     = local.kubeconfig
    file_permission      = "0600"
    filename = "templates/kubeconfig"
}

resource "local_file" "config_map_aws_auth" {
    content     = local.config_map_aws_auth
    file_permission      = "0600"
    filename = "templates/config_map_aws_auth.yaml"
}

resource "null_resource" "update_config_map_aws_auth" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.config_map_aws_auth.filename} --kubeconfig ${local_file.kubeconfig.filename}"
  }
}

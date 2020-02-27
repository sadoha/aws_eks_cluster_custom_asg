#
#  An example of default configuration environment inside of cloud
#  * The Nginx ingress controller based on AWS NLB 
#  * Test pods (apple,banana) for checking ingress configuration. 
#  * The ingress extension for pods (apple,banana) 
#

# Create template file in a templates directory 
resource "local_file" "ingress_controller_nlb" {
    content     = local.ingress_controller_nlb
    file_permission      = "0600"
    filename = "templates/ingress_controller_nlb.yaml"
}

# Apply the Kubernetes template file
resource "null_resource" "update_ingress_controller_nlb" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ingress_controller_nlb.filename} --kubeconfig ${var.kubeconfig}"
  }
}

# Create template file in a templates directory
resource "local_file" "apple_app" {
    content     = local.apple_app
    file_permission      = "0600"
    filename = "templates/apple_app.yaml"
}

# Apply the Kubernetes template file
resource "null_resource" "update_apple_app" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.apple_app.filename} --kubeconfig ${var.kubeconfig}"
  }
}

# Create template file in a templates directory
resource "local_file" "banana_app" {
    content     = local.banana_app
    file_permission      = "0600"
    filename = "templates/banana_app.yaml"
}

# Apply the Kubernetes template file
resource "null_resource" "update_banana_app" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.banana_app.filename} --kubeconfig ${var.kubeconfig}"
  }
}

# Create template file in a templates directory
resource "local_file" "ingress_extension" {
    content     = local.ingress_extension
    file_permission      = "0600"
    filename = "templates/ingress_extension.yaml"
}

# Apply the Kubernetes template file
resource "null_resource" "update_ingress_extension" {
  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ingress_extension.filename} --kubeconfig ${var.kubeconfig}"
  }
}


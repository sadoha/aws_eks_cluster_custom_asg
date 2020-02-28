# Defining the Ingress resource (with SSL termination) 
# to route traffic to the services created above 
# If you’ve purchased and configured a custom domain name for your server, 
# you can use that certificate, otherwise you can still use SSL with
# a self-signed certificate for development and testing.
#
# In this example, where we are terminating SSL on the backend, 
# we will create a self-signed certificate.
#
# Anytime we reference a TLS secret, we mean a PEM-encoded X.509, RSA (2048) secret. 
# Now generate a self-signed certificate and private key with:
#
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=sadoha.club/O=sadoha.club"
#
# Then create the secret in the cluster:
#
# kubectl create secret tls tls-secret --key tls.key --cert tls.crt
#

locals {
  ingress_extension = <<INGRESSEXTENSION
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-extension
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/whitelist-source-range: "${local.workstation-external-cidr}"
spec:
  tls:
  - hosts:
    - sadoha.club 
    secretName: tls-secret
  rules:
  - host: sadoha.club
    http:
      paths:
        - path: /apple
          backend:
            serviceName: apple-service
            servicePort: 5678
        - path: /banana
          backend:
            serviceName: banana-service
            servicePort: 5678
INGRESSEXTENSION
}

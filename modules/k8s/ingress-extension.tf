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
    - anthonycornell.com
    secretName: tls-secret
  rules:
  - host: anthonycornell.com
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

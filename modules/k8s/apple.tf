locals {
  apple_app = <<APPLEAPP
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: apple-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: apple-app
  template:
    metadata:
      name: apple-app
      labels:
        app: apple-app
    spec:
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                - key: k8s-app
                  operator: In
                  values:
                  - apple-app
              topologyKey: failure-domain.beta.kubernetes.io/zone
      containers:
      - name: apple-app
        image: hashicorp/http-echo
        args:
          - "-text=apple"
        ports:
        - containerPort: 5678
        readinessProbe:
          tcpSocket:
            port: 5678
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: 5678
          initialDelaySeconds: 15
          periodSeconds: 20
        resources:
          limits:
            cpu: '250m'
            memory: '128M'
          requests:
            cpu: '250m'
            memory: '128M'

---

kind: Service
apiVersion: v1
metadata:
  name: apple-service
spec:
  selector:
    app: apple-app
  ports:
    - port: 5678 # Default port for image
APPLEAPP
}

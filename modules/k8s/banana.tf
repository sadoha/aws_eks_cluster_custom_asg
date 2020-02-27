locals {
  banana_app = <<BANANAAPP
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: banana-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: banana-app
  template:
    metadata:
      name: banana-app
      labels:
        app: banana-app
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
                  - banana-app
              topologyKey: failure-domain.beta.kubernetes.io/zone
      containers:
      - name: banana-app
        image: hashicorp/http-echo
        args:
          - "-text=banana"
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
  name: banana-service
spec:
  selector:
    app: banana-app
  ports:
    - port: 5678 # Default port for image
BANANAAPP
}

{{{{- define "deployment" }}}}
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: {{cookiecutter.component_id}}
    backstage.io/kubernetes-id: {{cookiecutter.component_id}}
    slot: {{{{ .slot }}}}
  name: {{cookiecutter.component_id}}-{{{{ .slot }}}}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{cookiecutter.component_id}}
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: {{cookiecutter.component_id}}
        backstage.io/kubernetes-id: {{cookiecutter.component_id}}
        slot: {{{{ .slot }}}}
    spec:
      containers:
      - image: {{{{ .Values.config.image.name }}}}:{{{{ .Values.config.image.tag }}}}
        imagePullPolicy: IfNotPresent
        name: {{cookiecutter.component_id}}
        resources: {}
        ports:
          - containerPort: 8080 
        readinessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          periodSeconds: 5
status: {}
{{{{- end }}}}

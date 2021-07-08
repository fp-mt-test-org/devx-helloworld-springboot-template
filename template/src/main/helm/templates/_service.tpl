{{{{- define "service" }}}}
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: {{cookiecutter.component_id}}
    backstage.io/kubernetes-id: {{cookiecutter.component_id}}
    slot: {{{{ .slot }}}}
  name: {{cookiecutter.component_id}}-{{{{ .slot }}}}
spec:
  ports:
  - name: 8080-8080
    port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    slot: {{{{ .slot }}}}
{{{{- end }}}}

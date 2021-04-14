FROM lachlanevenson/k8s-helm:v3.5.0 AS helm

FROM amazon/aws-cli:2.1.18
COPY --from=helm /usr/local/bin/helm /usr/local/bin/helm
ENTRYPOINT [ "/bin/sh" , "-c" ]
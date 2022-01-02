FROM alpine:3
LABEL maintainer="Golovanov Sergey <golovanovsv@gmail.com>"

ARG HELM_VERSION=3.7.1
ARG HELM_PUSH_VERSION=0.10.1

# Install helm
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN apk add --update --no-cache curl ca-certificates bash && \
    # Install helm
    mkdir /tmp/helm /tmp/helm-push && \
    curl -L ${BASE_URL}/${TAR_FILE} | tar -zxv -C /tmp/helm && \
    mv /tmp/helm/linux-amd64/helm /usr/bin/helm && rm -rf /tmp/helm && \
    chmod +x /usr/bin/helm && \
    # Install helm-push plugin
    curl -L https://github.com/chartmuseum/helm-push/releases/download/v${HELM_PUSH_VERSION}/helm-push_${HELM_PUSH_VERSION}_linux_amd64.tar.gz | tar -zxv -C /tmp/helm-push && \
    mv /tmp/helm-push/bin/helm-cm-push /usr/bin/helm-cm-push && rm -rf /tmp/helm-push && \
    chmod +x /usr/bin/helm-cm-push

# Install pip packages
RUN apk add --update --no-cache python3 py-pip yamllint && \
    apk del curl && \
    rm -rf linux-amd64 && \
    rm -f /var/cache/apk/*

WORKDIR /apps

FROM alpine:3
LABEL maintainer="Golovanov Sergey <golovanovsv@gmail.com>"

ARG HELM_VERSION=3.7.1
ARG KUBECTL_VERSION=1.20.11
ARG AWS_IAM_AUTH_VERSION=0.5.3
ARG EKSCTL_VERSION=0.70.0

# Install helm
ENV BASE_URL="https://get.helm.sh"
ENV TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"
RUN apk add --update --no-cache curl ca-certificates bash && \
    curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm

# Install kubectl
RUN apk add --update --no-cache curl && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod +x /usr/bin/kubectl

# Install aws-iam-authenticator
RUN curl -LO https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTH_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTH_VERSION}_linux_amd64 && \
    mv aws-iam-authenticator_${AWS_IAM_AUTH_VERSION}_linux_amd64 /usr/bin/aws-iam-authenticator && \
    chmod +x /usr/bin/aws-iam-authenticator

# Install eksctl (latest version)
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/v${EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/eksctl /usr/bin && \
    chmod +x /usr/bin/eksctl

# Install awscli
RUN apk add --update --no-cache aws-cli && \
    apk del curl && \
    rm -rf linux-amd64 && \
    rm -f /var/cache/apk/*

WORKDIR /apps

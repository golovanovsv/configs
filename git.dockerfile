FROM alpine:3
LABEL maintainer="Golovanov Sergey <golovanovsv@gmail.com>"

RUN apk --update add git openssh ca-certificates curl

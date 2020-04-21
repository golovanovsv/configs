#!/bin/bash
# Необходимые настройки registry:
# http:
#   addr: :5000
#   headers:
#     Access-Control-Allow-Origin: ['*']

docker run --name docker-ui -d \
  -p 3080:80 \
  -e REGISTRY_URL=http://127.0.0.1:5000/ \
joxit/docker-registry-ui
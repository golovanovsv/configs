#!/bin/bash

docker run -d --name kibana \
  --network host \
  --pid host \
  --restart unless-stopped \
  -p "5601:5601" \
  -e "SERVER_NAME=kibana" \
  -e "ELASTICSEARCH_HOSTS=http://77.244.217.237:9200" \
docker.elastic.co/kibana/kibana:7.6.1

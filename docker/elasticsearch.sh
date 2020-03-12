#!/bin/bash

docker run -d --name elasticsearch \
  --network host \
  --pid host \
  --restart unless-stopped \
  -p "9200:9200" \
  -p "9300:9300" \
  --volume "/data/elasticsearch:/usr/share/elasticsearch/data" \
  -e "discovery.type=single-node" \
  -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
docker.elastic.co/elasticsearch/elasticsearch:7.6.1

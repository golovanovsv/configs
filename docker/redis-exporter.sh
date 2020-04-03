#!/bin/bash

docker run -d --name redis-exporter \
  --restart unless-stopped \
  -p 9121:9121 \
oliver006/redis_exporter \
  -redis-only-metrics \
  -redis.addr redis://redis:6379

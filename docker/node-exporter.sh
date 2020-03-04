#!/bin/bash

docker run -d --name node-exporter \
  --network host \
  --pid host \
  --restart unless-stopped \
  --volume "/:/host:ro,rslave" \
  --volume "/usr/share/node-exporter:/usr/share/node-exporter:ro" \
prom/node-exporter \
  /bin/node_exporter \
  --web.listen-address=0.0.0.0:9100 \
  --path.rootfs=/host \
  --collector.textfile.directory=/usr/share/node-exporter \
  --collector.filesystem.ignored-mount-points="^/(sys|proc|dev|host|etc)($|/)" \
  --collector.ntp

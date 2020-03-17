#!/bin/bash

docker run -d --name etcd-k0 \
  --network host \
  --pid host \
quay.io/coreos/etcd:v3.1.10 \
  etcd \
  --advertise-client-urls=http://192.168.36.10:2379 \
  --initial-advertise-peer-urls=http://192.168.36.10:2380 \
  --initial-cluster="k0=http://192.168.36.10:2380" \
  --initial-cluster-token etcd-cluster \
  --listen-client-urls=http://0.0.0.0:2379 \
  --listen-peer-urls=http://0.0.0.0:2380 \
  --name=k0

docker run -d --name etcd-k1 \
  --network host \
  --pid host \
quay.io/coreos/etcd:v3.1.10 \
  etcd \
  --advertise-client-urls=http://192.168.36.13:2379 \
  --initial-advertise-peer-urls=http://192.168.36.13:2380 \
  --initial-cluster="k1=http://192.168.36.13:2380,k0=http://192.168.36.10:2380" \
  --initial-cluster-token etcd-cluster \
  --initial-cluster-state=existing \
  --listen-client-urls=http://0.0.0.0:2379 \
  --listen-peer-urls=http://0.0.0.0:2380 \
  --name=k1

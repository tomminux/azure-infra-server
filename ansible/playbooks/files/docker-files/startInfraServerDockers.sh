#!/bin/bash

docker run -d \
    -p 10.160.20.20:5000:5000 \
    --restart=always \
    --name xwideRegistry \
    -v /home/ubuntu/dockerhost-storage/registry/ca-certificates:/certs \
    -v /home/ubuntu/dockerhost-storage/registry/var-lib-registry:/var/lib/registry \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.az.x-wide.cloud.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/registry.az.x-wide.cloud.key \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
    registry:2
    
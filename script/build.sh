#!/bin/sh

set -e

# Build the binary in a docker image
docker build -t mirage-demo:virtio -f script/virtio.Dockerfile .

# Copy the binary from the docker image to our temporary directory
docker create -ti --name dummy mirage-demo:virtio sh
docker cp dummy:/opt/app/mirage/mirage-demo-latest.tar.gz mirage-demo-latest.tar.gz
docker rm -f dummy

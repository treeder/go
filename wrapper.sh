#!/bin/bash

case "$1" in
  build) docker run --rm -v $PWD:/app -w /app treeder/go build ;;
  cross) docker run --rm -v $PWD:/app -w /app treeder/go cross ;;
  static) docker run --rm -v $PWD:/app -w /app treeder/go static ;;
  vendor) docker run --rm -v $PWD:/app -w /app treeder/go vendor ;;
  image) \
    if [ -z "$2" ]; then
      echo "Missing image name"
      exit 1
    fi
    docker run --rm -v $PWD:/app -w /app -v /var/run/docker.sock:/var/run/docker.sock treeder/go image $1
    ;;
esac
exit 0

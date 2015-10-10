#!/usr/bin/env bash
set -eo pipefail; [[ $TRACE ]] && set -x

main() {
  case "$1" in
    build)
      docker run --rm -v "$PWD":/app -w /app treeder/go build
      ;;
    cross)
      docker run --rm -v "$PWD":/app -w /app treeder/go cross
      ;;
    static)
      docker run --rm -v "$PWD":/app -w /app treeder/go static
      ;;
    vendor)
      docker run --rm -v "$PWD":/app -w /app treeder/go vendor
      ;;
    fmt)
      docker run --rm -v "$PWD":/app -w /app treeder/go fmt
      ;;
    run)
      docker run --rm -v "$PWD":/app -w /app -p 8080:8080 iron/base ./app
      ;;
    run-static)
      docker run --rm -v "$PWD":/app -w /app -p 8080:8080 iron/base ./static
      ;;
    image)
      local image="$2"
      if [[ -z "$image" ]]; then
        echo "Missing image name"
        exit 1
      fi
      docker run --rm -v "$PWD":/app -w /app -v /var/run/docker.sock:/var/run/docker.sock treeder/go image "$image"
      ;;
    *)
      echo "Invalid command"
      exit 1
      ;;
  esac
}

main "$@"

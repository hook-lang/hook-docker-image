#!/usr/bin/env bash

REPOSITORY_NAME="$1"

#docker push fabiosvm/hook:latest

docker push "$REPOSITORY_NAME/$IMAGE_NAME:latest"

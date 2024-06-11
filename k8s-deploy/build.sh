#!/bin/sh
set -e
IMAGE_TAG="k8s-deploy"

docker build -t ${IMAGE_TAG} .
docker image ls | grep ${IMAGE_TAG}
docker tag ${IMAGE_TAG}:latest localhost:5000/${IMAGE_TAG}:latest
docker push localhost:5000/${IMAGE_TAG}:latest
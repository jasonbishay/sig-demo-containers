#!/bin/sh
set -e
IMAGE_NAME="bridge"
IMAGE_TAG="latest"
REG="localhost:5000"


docker build -t ${IMAGE_NAME} .
docker image ls | grep ${IMAGE_NAME}
docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REG}/${IMAGE_NAME}:${IMAGE_TAG}
docker push ${REG}/${IMAGE_NAME}:${IMAGE_TAG}

docker run -it ${REG}/${IMAGE_NAME}:${IMAGE_TAG}

exit 0



#!/bin/sh
set -e
IMAGE_NAME="synopsys-sig-tools"
IMAGE_TAG="java11-srm"
REG="localhost:5000"

# Set versions, for latest set versions to nil.
CTC_VERSION="2023.6.1"
DETECT_VERSION="8.9.0"
BRIDGE_VERSION=""
BRIDGE_API_KEY=""
BASE_BUILD_IMAGE="mcr.microsoft.com/openjdk/jdk:11-ubuntu"
RUN_IMAGE=false


# Set Bridge URL based on wanted version
BRIDGE_URL=""
if [ -z "$BRIDGE_VERSION" ]; 
then
    BRIDGE_URL="https://sig-repo.synopsys.com/artifactory/bds-integrations-release/com/synopsys/integration/synopsys-bridge/latest/synopsys-bridge-linux64.zip"
else
    BRIDGE_URL="https://sig-repo.synopsys.com/artifactory/bds-integrations-release/com/synopsys/integration/synopsys-bridge/${BRIDGE_VERSION}/synopsys-bridge-${BRIDGE_VERSION}-linux64.zip"
fi

# Get CTC latest version
# we can easily get this from the helm chart (what a hack)
if [ -z "$CTC_VERSION" ]; 
then
    CTC_VERSION=$(helm show chart --repo https://sig-repo.synopsys.com/artifactory/sig-cloudnative cnc | grep appVersion: | head -1 | sed 's/.*://' | sed 's/,//g' | sed "s/'//g")
fi

# Detect latest is already determined during the build if DETECT_VERSION is blank

# Get SRM Versions for Detect and CTC scanfarm.sast.version and scanfarm.sca.version
#SRM_CTC_VERSION=$(helm show chart --repo https://synopsys-sig.github.io/srm-k8s srm | yq '.dependencies[] | select(.name == "cnc").version' -)
SRM_CTC_VERSION=$(helm show values --repo https://synopsys-sig.github.io/srm-k8s srm | yq '.web.scanfarm.sast.version' -)
SRM_DETECT_VERSION=$(helm show values --repo https://synopsys-sig.github.io/srm-k8s srm | yq '.web.scanfarm.sca.version' -)




# Build Images
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} . --env DETECT_RELEASE_VERSION=${DETECT_VERSION} --build-arg BRIDGECLI_LINUX64=${BRIDGE_URL} --build-arg BASE_BUILD_IMAGE=${BASE_BUILD_IMAGE} --build-arg CTC_VERSION=${CTC_VERSION} --build-arg SIG_REPO_USER="$DOCKER_USER" --build-arg SIG_REPO_PASS="$DOCKER_PASS"
docker image ls | grep ${IMAGE_NAME}

# Push to remote registry
if [ -n "$REG" ]; then
    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${REG}/${IMAGE_NAME}:${IMAGE_TAG}
    docker push ${REG}/${IMAGE_NAME}:${IMAGE_TAG}
fi


docker run --env-file env_vars.env --env BRIDGE_SRM_ASSESSMENT_TYPES="SAST" --env BRIDGE_SRM_APIKEY="${BRIDGE_API_KEY}" -it ${IMAGE_NAME}:${IMAGE_TAG}

exit 0



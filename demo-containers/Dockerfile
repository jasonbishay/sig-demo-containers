ARG BASE_BUILD_IMAGE="bitnami/java:11.0.21-10-debian-11-r1"
FROM alpine:latest as tools-builder
USER root

# Arguments for Thin Client Download, user and pass must be passed in when building the image
ARG SIG_REPO_USER
ARG SIG_REPO_PASS
ARG CTC_VERSION="2023.9.2"
ARG BRIDGE_VERSION=""


# Install needed utilities
RUN apk add curl zip bash

# Variables for tools install
# Bridge Download URL
ARG BRIDGECLI_LINUX64="https://sig-repo.synopsys.com/artifactory/bds-integrations-release/com/synopsys/integration/synopsys-bridge/latest/synopsys-bridge-linux64.zip"
# Only download detect jar
ENV DETECT_DOWNLOAD_ONLY="1"
ENV SYNOPSYS_TOOLS_HOME="/synopsys"
ENV BRIDGE_HOME=${SYNOPSYS_TOOLS_HOME}/bridge
ENV DETECT_HOME=$SYNOPSYS_TOOLS_HOME/detect
ENV DETECT_JAR_DOWNLOAD_DIR=${DETECT_HOME}
ENV DETECT_RELEASE_VERSION=""
ENV CTC_HOME=$SYNOPSYS_TOOLS_HOME/coverity-thin-client
ENV SCRIPTS_HOME=${SYNOPSYS_TOOLS_HOME}/scripts
ENV BRIDGE_BLACKDUCK_EXECUTION_PATH=${DETECT_HOME}
ENV BRIDGE_COVERITY_EXECUTION_PATH=${CTC_HOME}

# Install Bridge, DETECT JAR, and THIN CLIENT
RUN mkdir -p ${SCRIPTS_HOME} && mkdir -p ${BRIDGE_HOME} && \
    curl -fLsS -o bridge.zip $BRIDGECLI_LINUX64 && unzip -qo -d ${BRIDGE_HOME} bridge.zip && rm -f bridge.zip && \
    mkdir -p ${DETECT_HOME} && \
    bash <(curl -s -L https://detect.synopsys.com/detect9.sh) && \
    mkdir -p ${CTC_HOME} && curl -vfL -u ${SIG_REPO_USER}:${SIG_REPO_PASS} https://sig-repo.synopsys.com/artifactory/coverity-releases/${CTC_VERSION}/cov-thin-client-linux64-${CTC_VERSION}.tar.gz > ${CTC_HOME}/cov-thin-client.tar.gz && \
    tar -xzf ${CTC_HOME}/cov-thin-client.tar.gz -C ${CTC_HOME} && rm ${CTC_HOME}/cov-thin-client.tar.gz && chmod -R 755 ${SYNOPSYS_TOOLS_HOME}


#############################################################################################################################
FROM ${BASE_BUILD_IMAGE}
USER root

# Set environemnt variables
# ENV SRM_HOST="srm-gcp.chuckaude.com"
# ENV BRIDGE_SRM_URL="https://${SRM_HOST}"
ENV BRIDGE_SRM_PROJECT_NAME=""
ENV BRIDGE_SRM_ASSESSMENT_TYPES="SAST,SCA"
ENV SYNOPSYS_TOOLS_HOME="/synopsys"
ENV BRIDGE_HOME=${SYNOPSYS_TOOLS_HOME}/bridge
ENV DETECT_HOME=$SYNOPSYS_TOOLS_HOME/detect
ENV CTC_HOME=$SYNOPSYS_TOOLS_HOME/coverity-thin-client/
ENV SCRIPTS_HOME=${SYNOPSYS_TOOLS_HOME}/scripts
ENV BRIDGE_BLACKDUCK_EXECUTION_PATH=${DETECT_HOME}
ENV BRIDGE_COVERITY_EXECUTION_PATH=${CTC_HOME}/bin/coverity
ENV BRIDGE_BLACKDUCK_EXECUTION_PATH=${DETECT_HOME}
ENV BRIDGE_COVERITY_EXECUTION_PATH=${CTC_HOME}
ENV HOME="/home/sig-user"

# install git and java build tools, add user:
RUN apt-get -y update && apt-get install -y --no-install-recommends curl git maven gradle && apt-get clean && rm -rf /var/lib/apt/lists/* && useradd -ms /bin/bash sig-user
COPY --chown=sig-user:sig-user srm_scan_job.sh "/home/sig-user"
COPY --chown=sig-user:sig-user cnc_scan_job.sh "/home/sig-user"
COPY --chown=sig-user:sig-user --from=tools-builder /synopsys /synopsys
ENV PATH="$PATH:${BRIDGE_HOME}:${CTC_HOME}/bin:${DETECT_HOME}"
#RUN chmod -R 777 /synopsys
# Copy scripts to run jobs
USER sig-user
WORKDIR /home/sig-user
ENTRYPOINT ["bash","/home/sig-user/srm_scan_job.sh"]
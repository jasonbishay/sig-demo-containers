FROM bitnami/java:11.0.21-10-debian-11-r1
USER root
RUN apt-get -y update && apt-get install -y curl apt-utils ca-certificates wget locales apt-utils
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Blackduck
ENV BLACKDUCK_URL="testing.blackduck.synopsys.com"
ENV BLACKDUCK_API_TOKEN=""

# Add certs to truststore, put any certs here:
COPY cert-mgr.crt /usr/local/share/ca-certificates
RUN update-ca-certificates


# DETECT_LATEST_RELEASE_VERSION should be set in your
# environment if you wish to use a version different
# from LATEST.
ENV DETECT_RELEASE_VERSION="9.1.0"

# To override the default version key, specify a
# different DETECT_VERSION_KEY in your environment and
# *that* key will be used to get the download url from
# artifactory. These DETECT_VERSION_KEY values are
# properties in Artifactory that resolve to download
# urls for the detect jar file.
ENV DETECT_VERSION_KEY="DETECT_LATEST_9"


# To override the default location of $HOME/synopsys-detect, specify
# your own DETECT_JAR_DOWNLOAD_DIR in your environment and
# *that* location will be used.
# *NOTE* We currently do not support spaces in the
# DETECT_JAR_DOWNLOAD_DIR.
ENV DETECT_JAR_DOWNLOAD_DIR="/synopsys/detect"

# To control which java detect will use to run, specify
# the path in in DETECT_JAVA_PATH or JAVA_HOME in your
# environment, or ensure that java is first on the path.
# DETECT_JAVA_PATH will take precedence over JAVA_HOME.
# JAVA_HOME will take precedence over the path.
# Note: DETECT_JAVA_PATH should point directly to the
# java executable. For JAVA_HOME the java executable is
# expected to be in JAVA_HOME/bin/java
ENV DETECT_JAVA_PATH=""

# If you want to pass any java options to the
# invocation, specify DETECT_JAVA_OPTS in your
# environment. For example, to specify a 6 gigabyte
# heap size, you would set DETECT_JAVA_OPTS=-Xmx6G.
ENV DETECT_JAVA_OPTS=""

# If you want to pass any additional options to
# curl, specify DETECT_CURL_OPTS in your environment.
# For example, to specify a proxy, you would set
# DETECT_CURL_OPTS=--proxy http://myproxy:3128
ENV DETECT_CURL_OPTS=""

# If you only want to download the appropriate jar file set
# this to 1 in your environment. This can be useful if you
# want to invoke the jar yourself but do not want to also
# get and update the jar file when a new version releases.
ENV DETECT_DOWNLOAD_ONLY="1"

RUN echo $DETECT_JAR_DOWNLOAD_DIR
RUN bash <(curl -s -L https://detect.synopsys.com/detect9.sh) && chmod 755 ${DETECT_JAR_DOWNLOAD_DIR}/synopsys-detect-${DETECT_RELEASE_VERSION}.jar

#ARG DETECT_VERSION="8.9.0"
#ARG DETECT_SOURCE=https://sig-repo.synopsys.com/artifactory/bds-integrations-release/com/synopsys/integration/synopsys-detect/${DETECT_VERSION}/synopsys-detect-${DETECT_VERSION}.jar
#RUN wget -O /synopsys-detect.jar --server-response ${DETECT_SOURCE} 

USER 1000

ENTRYPOINT ["java", "-jar", "/synopsys/detect/synopsys-detect-9.1.0.jar", "--detect.source.path=/source", "--detect.output.path=/output", "--detect.phone.home.passthrough.invoked.by.image=true", "--blackduck.url=${BLACKDUCK_URL}", "detect.test.connection=true" , "--detect.accuracy.required=NONE"]

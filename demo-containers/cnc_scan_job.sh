#!/bin/bash

set -x
echo $COV_USER
echo $COVERITY_PASSPHRASE

coverity scan --help
coverity scan  --scm-url "$SCM_URL" -o analyze.location=connect -o commit.connect.on-new-cert=distrust -o caching.enabled=true -o commit.connect.url="$COV_URL" -o commit.connect.stream="$COV_STREAM" # -- "${BUILD_CMD}"

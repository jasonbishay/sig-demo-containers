#!/bin/bash

set -x #e
# This script runs a scan job using Software Risk Manager
# Populate the variables below to match your settings, ensure you have an API key generated with the correct permissions

# export BRIDGECLI_LINUX64="https://sig-repo.synopsys.com/artifactory/bds-integrations-release/com/synopsys/integration/synopsys-bridge/latest/synopsys-bridge-linux64.zip"
# CLIENT_DIR="/tmp/synopsys-bridge-client"
# echo "Installing Synopsys Bridge client..."
# mkdir -p "${CLIENT_DIR}"
# ls -l ${CLIENT_DIR}
# curl -fLsS -o bridge.zip $BRIDGECLI_LINUX64 && unzip -qo -d ${CLIENT_DIR} bridge.zip && rm -f bridge.zip
# ls -l ${CLIENT_DIR}

# Clone/Pull Project:
echo "Clone Project..."
cd "$(mktemp -d)" && git clone $SCM_URL .
#cd "$(mktemp -d)" && git clone $SCM_URL 2> /dev/null
ls -l
# Run scan job:
echo "Running scan job..."
# --json-log  print logs in json format
# --home /tmp change bridge home
synopsys-bridge --debug --verbose --stage srm 

#synopsys-bridge --debug --verbose --stage connect 

ls -la
ls -ls .bridge
#ls -la /synopsys

cat .bridge/bridge.log

#echo ${PATH}
FROM docker.io/bitnami/kubectl:latest

USER root
RUN apt-get -y update && apt-get install -y curl apt-utils ca-certificates jq apt-transport-https gnupg
# Add certs to trust
COPY cert-mgr.crt /usr/local/share/ca-certificates
RUN update-ca-certificates
# Install Helm
RUN cd /home \
	&& curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
	&& chmod 700 get_helm.sh \
    && ./get_helm.sh \
	&& rm get_helm.sh \
	&& helm --help \
	&& curl -sSL https://get.docker.com/ | sh \
	&& newgrp docker \
	&& useradd -ms /bin/bash 1000 \
	&& adduser 1000 docker \
	&& usermod -aG docker 1000 \
	&& chmod 777 /var/run

# Install GCP UTILS:
	# add cli repo
	# install client	
	# install auth plugin
	# run init, enter and configure your gcloud cli by answering the prompts
	# install jq to parse json output for values needed in the CNC deployment
# COPY gcp_service_account.json /home
# RUN cd /home \
#   && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
#   && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.gpg \
#   && apt-get update -y && apt-get install -y google-cloud-cli dnsutils \
#   && apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin \
#   && gcloud auth activate-service-account --key-file gcp_service_account.json \
#   && gcloud config set project sig-sa-sandbox-335916 \
#   && gcloud config set compute/region us-west4 \
#   && gcloud config set compute/zone us-west4-a \
#   && gcloud config configurations list

USER 1000

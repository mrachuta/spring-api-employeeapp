#!/bin/bash

WORKDIR='/opt/employeeapp'
SECRET_VER=$(/usr/bin/curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/config_secret_version)
SECRET_NAME=$(/usr/bin/curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/attributes/config_secret_name)

gcloud secrets versions access "${SECRET_VER}" \
--secret="${SECRET_NAME}" \
--out-file="${WORKDIR}/application-gcp.properties"

chmod 640 "${WORKDIR}/application-gcp.properties"

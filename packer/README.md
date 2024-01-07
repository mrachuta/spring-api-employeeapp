## Table of contents
- [Table of contents](#table-of-contents)
- [General info](#general-info)
- [Requirements](#requirements)
- [Usage](#usage)

## General info

Packer configuration to create employeeapp GCP image.

## Requirements
* Exported variable
  ```
  export GOOGLE_PROJECT=myproject
  ```
* compute.googleapis.com service enabled
  ```
  gcloud services enable compute.googleapis.com
  ```
* Service account to use with Packer created :
  ```
  gcloud iam service-accounts create packer-sa \
  --description="Service account used to build images by packer" \
  --display-name="packer-sa"
  ```
* Permissions granted to service account:
  ```
  gcloud projects add-iam-policy-binding $GOOGLE_PROJECT --member="serviceAccount:packer-sa@${GOOGLE_PROJECT}.iam.gserviceaccount.com" --role="roles/compute.instanceAdmin.v1"
  gcloud projects add-iam-policy-binding $GOOGLE_PROJECT --member="serviceAccount:packer-sa@${GOOGLE_PROJECT}.iam.gserviceaccount.com" --role="roles/iap.tunnelResourceAccessor"
  gcloud projects add-iam-policy-binding $GOOGLE_PROJECT --member="serviceAccount:packer-sa@${GOOGLE_PROJECT}.iam.gserviceaccount.com" --role="roles/iam.serviceAccountUser"
  ```
* Network resources created:
  ```
  gcloud compute networks create packer-network \
  --description="Network to build images via packer" \
  --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional

  gcloud compute networks subnets create packer-network-subnet-01 \
  --range=10.0.10.0/24 --stack-type=IPV4_ONLY \
  --network=packer-network --region=us-central1 \
  --enable-private-ip-google-access

  gcloud compute firewall-rules create packer-network-in-allow-iap \
  --direction=INGRESS --network=packer-network \
  --action=ALLOW --rules=tcp:22 --source-ranges=35.235.240.0/20

  gcloud compute routers create packer-network-router \
  --region=us-central1 --network=packer-network --advertisement-mode=CUSTOM \
  --description="Network router for packer-network"

  gcloud compute routers nats create packer-network-router-nat \
  --region=us-central1 --router=packer-network-router \
  --auto-allocate-nat-external-ips \
  --nat-custom-subnet-ip-ranges=packer-network-subnet-01
  ```
* Credentials to packer service account in JSON format:
  ```
  gcloud iam service-accounts keys create packer-sa-${GOOGLE_PROJECT}.json --iam-account packer-sa@${GOOGLE_PROJECT}.iam.gserviceaccount.com
  ```
* Exported variable with path to packer service account credentials:
  ```
  export GOOGLE_APPLICATION_CREDENTIALS=./terraform-service-account-credentials.json
  ```

## Usage
Init packer:
```
packer init config.pkr.hcl
```
Build image:
```
export PKR_VAR_project_id=$GOOGLE_PROJECT
packer build .
```
For create image using Jenkins, use *jenkinsfiles/30_create_image/Jenkinsfile* pipeline

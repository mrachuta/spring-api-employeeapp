## Table of contents
- [Table of contents](#table-of-contents)
- [General info](#general-info)
- [Requirements](#requirements)
- [Usage](#usage)

## General info

Terraform configuration to create employeeapp stack in GCP

## Requirements

* employeeapp image available in GCP
* Exported two variables:
  ```
  export GOOGLE_PROJECT=myproject
  export ENV_NAME=dev 
  ```
* Following APIs enabled:
  ```
  gcloud services enable storage.googleapis.com
  gcloud services enable cloudresourcemanager.googleapis.com
  gcloud services enable servicenetworking.googleapis.com
  gcloud services enable secretmanager.googleapis.com
  gcloud services enable sqladmin.googleapis.com
  gcloud services enable compute.googleapis.com
  ```
* Remote state bucket created:
  ```
  gsutil mb -p $GOOGLE_PROJECT -s STANDARD -l us-central1 --pap enforced gs://terraform-${ENV_NAME}-ea-state
  ```
* Service account for Nginx MIG created:
  ```
  gcloud iam service-accounts create ${ENV_NAME}-ea-nginx-sa \
  --description="SA to use with employeeapp stack nginx instances" \f
  --display-name="${ENV_NAME}-ea-nginx-sa"
  ```
* Service account for employeeapp MIG created:
  ```
  gcloud iam service-accounts create ${ENV_NAME}-ea-app-sa \
  --description="SA to use with employeeapp stack instances" \
  --display-name="${ENV_NAME}-ea-app-sa"
  ```
* Secret with employeeapp configuration (for content see for example file at $REPO_ROOT/src/main/resources/application-dev.properties):
  ```
  gcloud secrets create employeeapp-config --replication-policy="automatic"

  gcloud secrets versions add employeeapp-config --data-file=./application-${ENV_NAME}-gcp.properties

  gcloud secrets add-iam-policy-binding employeeapp-config \
  --member="serviceAccount:${ENV_NAME}-ea-app-sa@${GOOGLE_PROJECT}.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
  ```
* Service account to use with terraform already created in GCP and credentials in JSON file
* Another variable exported with path to terraform service account credentials
  ```
  export GOOGLE_APPLICATION_CREDENTIALS=./terraform-service-account-credentials.json
  ```

## Usage

Create resources:
```
terraform apply
```
Destroy resources:
```
terraform destroy
```

To deploy infrastructure using Jenkins, use *jenkinsfiles/50_deploy/Jenkinsfile* pipeline

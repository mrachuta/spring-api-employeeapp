# Get project name from GOOGLE_PROJECT env variable
data "google_client_config" "this" {}

module "main" {
  source                             = "../../main"
  project_name                       = data.google_client_config.this.project
  project_region                     = "us-central1"
  project_zone                       = "us-central1-b"
  webserver_network_name             = "prod-ea-net-01"
  webserver_subnetwork_name          = "subnet-01"
  app_network_name                   = "prod-ea-net-02"
  app_subnetwork_name                = "subnet-01"
  app_sa                             = "prod-ea-app-sa@${data.google_client_config.this.project}.iam.gserviceaccount.com"
  webserver_sa                       = "prod-ea-nginx-sa@${data.google_client_config.this.project}.iam.gserviceaccount.com"
  site_name                          = "employeeapp.nonexisti.ng"
  db_instance_name                   = "prod-ea-dbinst"
  db_instance_size                   = "db-custom-1-3840"
  # Intentional act :-)
  db_deletion_protection             = false
  db_encryption                      = true
  db_kms_key_path                    = "projects/${data.google_client_config.this.project}/locations/us-central1/keyRings/prod/cryptoKeys/cloudSqlKey"
  bucket_name                        = "prod-ea-nginx-bucket"
  bucket_encryption                  = true
  bucket_kms_key_path                = "projects/${data.google_client_config.this.project}/locations/us-central1/keyRings/prod/cryptoKeys/cloudStorageKey"
  webserver_http_port                = 80
  webserver_https_port               = 443
  webserver_mig_name                 = "prod-ea-nginx"
  webserver_mig_size                 = 3
  webserver_mig_machine_type         = "n1-standard-2"
  webserver_mig_disk_encryption      = true
  webserver_mig_disk_kms_key_path    = "projects/${data.google_client_config.this.project}/locations/us-central1/keyRings/prod/cryptoKeys/computeEngineKey"
  #webserver_mig_image_family_link   = ""
  #webserver_mig_specific_image_link = ""
  ext_lb_name                        = "prod-ea-lb-ext"
  int_lb_name                        = "prod-ea-lb-int"
  app_http_port                      = 8080
  #app_https_port                    = ""
  app_mig_name                       = "prod-ea-app"
  app_mig_size                       = 6
  app_mig_machine_type               = "n1-standard-2"
  app_mig_disk_encryption            = true
  app_mig_disk_kms_key_path          = "projects/${data.google_client_config.this.project}/locations/us-central1/keyRings/prod/cryptoKeys/computeEngineKey"
  app_mig_image_family_link          = "projects/${data.google_client_config.this.project}/global/images/family/employeeapp-image"
  #app_mig_specific_image_link       = ""
  app_config_secret_version          = 1
}

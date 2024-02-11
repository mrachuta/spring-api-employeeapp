# Get project name from GOOGLE_PROJECT env variable
data "google_client_config" "this" {}

module "main" {
  source                             = "../../main"
  project_name                       = data.google_client_config.this.project
  project_region                     = "us-central1"
  project_zone                       = "us-central1-b"
  webserver_network_name             = "dev-ea-net-01"
  webserver_subnetwork_name          = "subnet-01"
  app_network_name                   = "dev-ea-net-02"
  app_subnetwork_name                = "subnet-01"
  app_sa                             = "dev-ea-app-sa@${data.google_client_config.this.project}.iam.gserviceaccount.com"
  webserver_sa                       = "dev-ea-nginx-sa@${data.google_client_config.this.project}.iam.gserviceaccount.com"
  site_name                          = "employeeapp-dev.nonexisti.ng"
  db_instance_name                   = "dev-ea-dbinst"
  db_instance_size                   = "db-g1-small"
  db_deletion_protection             = false
  db_encryption                      = false
  db_enable_ssl                      = true
  db_ssl_mode                        = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  #db_kms_key_path                   = ""
  bucket_name                        = "dev-ea-nginx-bucket"
  bucket_encryption                  = false
  #bucket_kms_key_path               = ""
  webserver_http_port                = 80
  webserver_https_port               = 443
  webserver_mig_name                 = "dev-ea-nginx"
  webserver_mig_size                 = 1
  webserver_mig_machine_type         = "n1-standard-1"
  webserver_mig_disk_encryption      = false
  #webserver_mig_disk_kms_key_path   = ""
  #webserver_mig_image_family_link   = ""
  #webserver_mig_specific_image_link = ""
  ext_lb_name                        = "dev-ea-lb-ext"
  int_lb_name                        = "dev-ea-lb-int"
  app_http_port                      = 8080
  #app_https_port                    = ""
  app_mig_name                       = "dev-ea-app"
  app_mig_size                       = 3
  app_mig_machine_type               = "n1-standard-1"
  app_mig_disk_encryption            = false
  #app_mig_disk_kms_key_path         = ""
  app_mig_image_family_link          = "projects/${data.google_client_config.this.project}/global/images/family/employeeapp-image"
  #app_mig_specific_image_link       = ""
  app_config_secret_version          = 1
}

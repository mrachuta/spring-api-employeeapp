locals {
  project_name                      = var.project_name
  project_region                    = var.project_region
  project_zone                      = var.project_zone
  webserver_network_name            = var.webserver_network_name
  webserver_subnetwork_name         = var.webserver_subnetwork_name
  app_network_name                  = var.app_network_name
  app_subnetwork_name               = var.app_subnetwork_name
  app_sa                            = var.app_sa
  webserver_sa                      = var.webserver_sa
  site_name                         = var.site_name
  db_instance_name                  = var.db_instance_name
  db_instance_size                  = var.db_instance_size
  db_deletion_protection            = var.db_deletion_protection
  db_encryption                     = var.db_encryption
  db_kms_key_path                   = var.db_kms_key_path
  bucket_name                       = var.bucket_name
  bucket_encryption                 = var.bucket_encryption
  bucket_kms_key_path               = var.bucket_kms_key_path
  webserver_http_port               = var.webserver_http_port
  webserver_https_port              = var.webserver_https_port
  webserver_mig_name                = var.webserver_mig_name
  webserver_mig_size                = var.webserver_mig_size
  webserver_mig_machine_type        = var.webserver_mig_machine_type
  webserver_mig_disk_encryption     = var.webserver_mig_disk_encryption
  webserver_mig_disk_kms_key_path   = var.webserver_mig_disk_kms_key_path
  webserver_mig_image_family_link   = var.webserver_mig_image_family_link
  webserver_mig_specific_image_link = var.webserver_mig_specific_image_link
  ext_lb_name                       = var.ext_lb_name
  int_lb_name                       = var.int_lb_name
  app_http_port                     = var.app_http_port
  app_https_port                    = var.app_https_port
  app_mig_name                      = var.app_mig_name
  app_mig_size                      = var.app_mig_size
  app_mig_machine_type              = var.app_mig_machine_type
  app_mig_disk_encryption           = var.app_mig_disk_encryption
  app_mig_disk_kms_key_path         = var.app_mig_disk_kms_key_path
  app_mig_image_family_link         = var.app_mig_image_family_link
  app_mig_specific_image_link       = var.app_mig_specific_image_link
  app_config_secret_version         = var.app_config_secret_version
}

module "gcp_app_network_module" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-network-module?ref=v1.2.1"

  project_name  = local.project_name
  network_name  = local.app_network_name
  router_region = local.project_region
  subnetworks = {
    "${local.app_subnetwork_name}" = {
      ip_cidr_range     = "10.0.20.0/24"
      subnetwork_region = local.project_region
    }
  }
}

module "gcp_webserver_network_module" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-network-module?ref=v1.2.1"

  project_name  = local.project_name
  network_name  = local.webserver_network_name
  router_region = local.project_region
  subnetworks = {
    "${local.webserver_subnetwork_name}" = {
      ip_cidr_range     = "10.0.21.0/24"
      subnetwork_region = local.project_region
    }
  }
}

module "gcp_cloudsql_module" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-cloudsql-module?ref=v1.2.1"

  project_name           = local.project_name
  db_region              = local.project_region
  db_instance_name       = local.db_instance_name
  db_instance_size       = local.db_instance_size
  db_deletion_protection = local.db_deletion_protection
  db_encryption          = local.db_encryption
  db_kms_key_path        = local.db_kms_key_path
  network_name           = module.gcp_app_network_module.network_id_output

  db_names = {
    db1 = "employeeapp"
  }

  db_users = {
    user1 = {
      user = "serviceAccount:${local.app_sa}"
      type = "CLOUD_IAM_SERVICE_ACCOUNT"
    }
  }
}

module "gcp_webserver_bucket" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-webserver-bucket-module?ref=v1.2.1"

  bucket_name         = local.bucket_name
  bucket_region       = local.project_region
  bucket_encryption   = local.bucket_encryption
  bucket_kms_key_path = local.bucket_kms_key_path
  site_name           = local.site_name
  http_port           = local.webserver_http_port
  https_port          = local.webserver_https_port
  generate_cert       = true
  custom_conf_file    = <<EOF
    upstream eacluster {
      # Value of lb_custom_ip_address from gcp_app_lb module
      server 10.0.20.100:8080;
    }
    server {
      # HTTP configuration
      listen ${local.webserver_http_port} default_server;
      listen [::]:${local.webserver_http_port} default_server;
      # SSL configuration
      listen ${local.webserver_https_port} ssl default_server;
      listen [::]:${local.webserver_https_port} ssl default_server;
      ssl_certificate /etc/ssl/${local.site_name}/${local.site_name}.crt;
      ssl_certificate_key /etc/ssl/${local.site_name}/${local.site_name}.key;

      location / {
        proxy_pass              http://eacluster/;
        proxy_redirect          off;
        proxy_set_header        Host            $host;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        client_max_body_size    10m;
        client_body_buffer_size 128k;
        proxy_connect_timeout   90;
        proxy_send_timeout      90;
        proxy_read_timeout      90;
        proxy_buffers           32 4k;
      }
    }
  EOF
}

module "gcp_webserver_mig" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-mig-module?ref=v1.2.1"

  project_name              = local.project_name
  mig_region                = local.project_region
  mig_zone                  = local.project_zone
  mig_service_account_email = local.webserver_sa
  mig_name                  = local.webserver_mig_name
  mig_description           = "MIG with machines that are running nginx for employeeapp"
  mig_size                  = local.webserver_mig_size
  mig_machine_type          = local.webserver_mig_machine_type
  mig_disk_encryption       = local.webserver_mig_disk_encryption
  mig_disk_kms_key_path     = local.webserver_mig_disk_kms_key_path
  nginx_bucket_name         = module.gcp_webserver_bucket.bucket_name_output
  site_name                 = module.gcp_webserver_bucket.site_name_output
  http_port                 = module.gcp_webserver_bucket.http_port_output
  https_port                = module.gcp_webserver_bucket.https_port_output

  # TODO: Update for custom.conf
  mig_startup_script = <<EOF
    #!/bin/bash

    sudo apt -y update
    sudo apt -y install nginx
    nginx_bucket=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/nginx_bucket_name" -H "Metadata-Flavor: Google")
    site_name=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/nginx_bucket_name" -H "Metadata-Flavor: Google")
    mkdir /var/www/html/${module.gcp_webserver_bucket.site_name_output}
    gsutil cp -R gs://${module.gcp_webserver_bucket.bucket_name_output}/*.{html,htm} /var/www/html/${module.gcp_webserver_bucket.site_name_output}/
    gsutil cp -R gs://${module.gcp_webserver_bucket.bucket_name_output}/custom.conf /etc/nginx/sites-available/custom.conf
    gsutil cp -R gs://${module.gcp_webserver_bucket.bucket_name_output}/nginx.conf /etc/nginx/nginx.conf
    chown -R www-data:www-data /var/www/html/${module.gcp_webserver_bucket.site_name_output}
    chown www-data:www-data /etc/nginx/sites-available/custom.conf /etc/nginx/nginx.conf
    ssl_enabled=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/ssl_enabled" -H "Metadata-Flavor: Google")
    if [ "$ssl_enabled" == 'true' ]; then
      echo 'ssl_enabled flag found...'
      mkdir /etc/ssl/${module.gcp_webserver_bucket.site_name_output}
      gsutil cp -R gs://${module.gcp_webserver_bucket.bucket_name_output}/*.{crt,key} /etc/ssl/${module.gcp_webserver_bucket.site_name_output}/
      chown -R www-data:www-data /etc/ssl/${module.gcp_webserver_bucket.site_name_output}
    fi
    ln -s /etc/nginx/sites-available/custom.conf /etc/nginx/sites-enabled/custom.conf
    rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default
    sudo systemctl enable --now nginx
    sudo systemctl restart nginx
    EOF

  network_name = module.gcp_webserver_network_module.network_id_output
  # TODO: Ugly syntax
  subnetwork_name = module.gcp_webserver_network_module.subnetworks_output[0][local.webserver_subnetwork_name].name

  additional_networks = {
    app_network = {
      network_name    = module.gcp_app_network_module.network_id_output
      subnetwork_name = module.gcp_app_network_module.subnetworks_output[0][local.app_subnetwork_name].name
    }
  }
}

module "gcp_webserver_lb" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-tcp-loadbalancer-module?ref=v1.2.1"

  lb_region    = local.project_region
  lb_name      = local.ext_lb_name
  external_lb  = true
  mig_name     = module.gcp_webserver_mig.instance_group_output
  network_name = module.gcp_webserver_network_module.network_id_output
  http_port    = module.gcp_webserver_mig.http_port_output
  https_port   = module.gcp_webserver_mig.https_port_output
}

module "gcp_app_mig" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-mig-module?ref=v1.2.1"

  project_name              = local.project_name
  mig_region                = local.project_region
  mig_zone                  = local.project_zone
  mig_service_account_email = local.app_sa
  mig_service_account_additional_roles = {
    cloudsql_client_role   = "roles/cloudsql.client"
    cloudsql_instance_user = "roles/cloudsql.instanceUser"
  }
  mig_name                = local.app_mig_name
  mig_description         = "MIG with machines that are running employeeapp"
  mig_size                = local.app_mig_size
  mig_machine_type        = local.app_mig_machine_type
  mig_image_family_link   = local.app_mig_image_family_link
  mig_specific_image_link = local.app_mig_specific_image_link
  mig_disk_encryption     = local.app_mig_disk_encryption
  mig_disk_kms_key_path   = local.app_mig_disk_kms_key_path
  mig_additional_metadata = {
    config_secret_version      = local.app_config_secret_version
    config_secret_name         = "employeeapp-config"
    database_connection_string = module.gcp_cloudsql_module.db_connection_string_output
  }
  http_port = local.app_http_port

  network_name    = module.gcp_app_network_module.network_id_output
  subnetwork_name = module.gcp_app_network_module.subnetworks_output[0][local.app_subnetwork_name].name

  depends_on = [
    module.gcp_cloudsql_module
  ]
}

module "gcp_app_lb" {
  source = "github.com/mrachuta/terraform-resources.git//modules/gcp-tcp-loadbalancer-module?ref=v1.2.1"

  lb_region            = local.project_region
  lb_name              = local.int_lb_name
  external_lb          = false
  lb_custom_ip_address = "10.0.20.100"
  mig_name             = module.gcp_app_mig.instance_group_output
  network_name         = module.gcp_app_network_module.network_id_output
  subnetwork_name      = module.gcp_app_network_module.subnetworks_output[0][local.app_subnetwork_name].name
  http_port            = module.gcp_app_mig.http_port_output
  https_port           = module.gcp_app_mig.https_port_output
}

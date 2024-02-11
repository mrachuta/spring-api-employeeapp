variable "project_name" {
  type = string
}

variable "project_region" {
  type = string
}

variable "project_zone" {
  type = string
}

variable "webserver_network_name" {
  type = string
}

variable "webserver_subnetwork_name" {
  type = string
}

variable "app_network_name" {
  type = string
}

variable "app_subnetwork_name" {
  type = string
}

variable "app_sa" {
  type = string
}

variable "webserver_sa" {
  type = string
}

variable "site_name" {
  type = string
}

variable "db_instance_name" {
  type = string
}

variable "db_instance_size" {
  type = string
}

variable "db_deletion_protection" {
  type    = bool
  default = false
}

variable "db_encryption" {
  type    = bool
  default = false
}

variable "db_kms_key_path" {
  type    = string
  default = null
}

variable "db_ssl_mode" {
  type = string
  default = null
}

variable "bucket_name" {
  type = string
}

variable "bucket_encryption" {
  type = string
}

variable "bucket_kms_key_path" {
  type    = string
  default = null
}

variable "webserver_http_port" {
  type    = number
  default = 80
}

variable "webserver_https_port" {
  type    = number
  default = 443
}

variable "webserver_mig_name" {
  type = string
}

variable "webserver_mig_size" {
  type = number
}

variable "webserver_mig_machine_type" {
  type = string
}

variable "webserver_mig_disk_encryption" {
  type    = bool
  default = false
}

variable "webserver_mig_disk_kms_key_path" {
  type    = string
  default = null
}

variable "webserver_mig_image_family_link" {
  type    = string
  default = "projects/debian-cloud/global/images/family/debian-11"
}

variable "webserver_mig_specific_image_link" {
  type    = string
  default = null
}

variable "ext_lb_name" {
  type = string
}

variable "int_lb_name" {
  type = string
}

variable "app_http_port" {
  type    = number
  default = 80
}

variable "app_https_port" {
  type    = number
  default = null
}

variable "app_mig_name" {
  type = string
}

variable "app_mig_size" {
  type = number
}

variable "app_mig_machine_type" {
  type = string
}

variable "app_mig_disk_encryption" {
  type    = bool
  default = false
}

variable "app_mig_disk_kms_key_path" {
  type    = string
  default = null
}

variable "app_mig_image_family_link" {
  type = string
}

variable "app_mig_specific_image_link" {
  type    = string
  default = null
}

variable "app_config_secret_version" {
  type = number
}

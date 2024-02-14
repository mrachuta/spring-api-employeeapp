variable "project_id" {
  type    = string
  default = "myproject"
}

variable "zone" {
  type    = string
  default = "us-central1-f"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "network" {
  type    = string
  default = "projects/myproject/global/networks/packer-network"
}

variable "subnetwork" {
  type    = string
  default = "projects/myproject/regions/us-central1/subnetworks/packer-network-subnet-01"
}

packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/googlecompute"
    }
  }
}

locals {
    image_timestamp = timestamp()
    project_id = var.project_id
}

source "googlecompute" "employeeapp-image" {
  project_id          = local.project_id
  source_image_family = "debian-11"
  ssh_username        = "packer-sa"
  zone                = var.zone
  region              = var.region
  disk_size           = var.disk_size
  machine_type        = var.machine_type
  image_name          = "employeeapp-${formatdate("YYYYMMDDhhmmss", local.image_timestamp)}"
  image_description   = "employeeapp image - created at ${local.image_timestamp}"
  image_family        = "employeeapp-image"
  network             = "projects/${local.project_id}/global/networks/packer-network"
  subnetwork          = "projects/${local.project_id}/regions/us-central1/subnetworks/packer-network-subnet-01"
  use_internal_ip     = true
  omit_external_ip    = true
  use_iap             = true
  use_os_login        = true
}

build {
  sources = ["sources.googlecompute.employeeapp-image"]

  provisioner "file" {
    source      = "../target/employeeapp.war"
    destination = "/tmp/"
  }

  provisioner "file" {
    source      = "./files/"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "sudo curl https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.3.0/cloud-sql-proxy.linux.amd64 -o /tmp/cloud-sql-proxy",
      "sudo mkdir -p /etc/systemd/system/cloud-sql-proxy.d/",
      "sudo touch /etc/systemd/system/cloud-sql-proxy.d/cloud-sql-proxy.conf",
      "sudo chmod 640 /etc/systemd/system/cloud-sql-proxy.d/cloud-sql-proxy.conf",
      "sudo chmod 755 /tmp/cloud-sql-proxy",
      "sudo chown root:root /tmp/cloud-sql-proxy",
      "sudo mv /tmp/cloud-sql-proxy /usr/bin/",
      "sudo mv /tmp/cloud-sql-proxy.service /etc/systemd/system/",
      "sudo apt update -y",
      "sudo apt install -y openjdk-17-jdk",
      "sudo useradd -m employeeapp",
      "sudo mkdir -p /opt/employeeapp",
      "sudo touch /opt/employeeapp/employeeapp.conf",
      "sudo mv /tmp/employeeapp.war /opt/employeeapp/",
      "sudo mv /tmp/employeeapp.service /etc/systemd/system/",
      "sudo mv /tmp/pre-start.sh /opt/employeeapp/",
      "sudo mv /tmp/start-app.sh /opt/employeeapp/",
      "sudo chown -R employeeapp:employeeapp /opt/employeeapp",
      "sudo chmod 755 /opt/employeeapp/*.war",
      "sudo chmod 755 /opt/employeeapp/*.sh",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable employeeapp.service",
      "sudo systemctl enable cloud-sql-proxy.service"
    ]
  }

}

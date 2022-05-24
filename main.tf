provider "google" {
version = "3.5.0"
credentials = file("<file path to your .json file from service account>")
project = var.project_id
region = var.region
zone = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "vpc-gritfy"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "public-subnetwork" {
name = "gritfy-subnetwork-public"
ip_cidr_range = "10.0.0.0/16"
region = var.region
network = google_compute_network.vpc_network.name
}

resource "google_compute_subnetwork" "private-subnetwork" {
name = "gritfy-subnetwork-private"
ip_cidr_range = "10.2.0.0/16"
region = var.region
network = google_compute_network.vpc_network.name
private_ip_google_access = "true"
}

resource "google_compute_instance" "public-gritfy-instance" {
  name         = "gritfy-public"
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = "gritfy-subnetwork-public"
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }
}

resource "google_compute_instance" "private-gritfy-instance" {
  name         = "gritfy-private"
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = "gritfy-subnetwork-private"
    access_config {
      # Allocate a one-to-one NAT IP to the instance
    }
  }

}

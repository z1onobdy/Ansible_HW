provider "google" {
  project = "homework-339713"
  region  = "europe-central2"
  zone    = "europe-central2-a"

}

resource "google_compute_instance" "Node" {
  count    = "2"
  name     = "node${count.index + 1}"
  hostname = "node${count.index + 1}.example.com"

  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8-v20211214"
    }
  }

  network_interface {
    network = "default"
  }
}

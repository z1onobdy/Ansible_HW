provider "google" {
  credentials = file("hw.json")
  project     = "HomeWork"
  region      = "europe-central2"
  zone        = "europe-central2-b"
}

resource "google_compute_instance" "Node" {
  count        = "2"
  name         = "node${count.index}"
  hostname     = "node${count.index}.example.com"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "centos-8/centos-8-v20211214"
    }
  }

  network_interface {
    network = "default"
  }
}

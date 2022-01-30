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
  metadata = {
    ssh-keys       = "z10:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfI+vsEcyM5j+tDU5F+BAhAdNbJo4AaGVDe7TceNvjvFY8ZAbQEv1IX3cS9Nel+EWmM6gMmd1VHKtts1Y+YfnmOo3mg0pjY4YtOsz4/WtGw+1qKeeTrpuomVwuh3kIbl/aOuNsczY5AH7uoeXy030o6UFGv3xm5zfiSiSEuaEl0eI3R7980bYrUioFlIBkbBKttbYdSYFJpCg1xtPv8J1U0Jjbtn4vvJaVdpzChTI1MIrokseXItnFS8YkEzEiROZUJ0TyFyGRIYBW8crXElCJFJoBuECPSxnfvLuUTnZ7iTt7d8q05lsrONiHbyEnjFyQIZzmGJlSCwwPh7X7K2In z10"
    enable-oslogin = "TRUE"
  }


  network_interface {
    network = "default"
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

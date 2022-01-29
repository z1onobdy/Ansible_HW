provider "google" {
credentials = file ()
project = "HomeWork"
region = "europe-central2"
zone = "europe-central2-b"
}

resource "google_compute_instance" "Node" {
count = "2"
name = "node${count.index}"
hostname = "node${count.index}.example.com"
machine_type = "e2-medium"
}

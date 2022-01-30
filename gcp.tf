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
    enable-oslogin = false
  }


  network_interface {
    network = "default"
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

resource "google_compute_instance" "cntrl" {
  name     = "cntrl"
  hostname = "cntrl.example.com"

  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8-v20211214"
    }
  }
  metadata = {
    enable-oslogin = false
  }

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = "z10"
      private_key = file("privnew1")
      host        = self.network_interface[0].access_config[0].nat_ip
    }

    inline = [
      "sudo yum install epel-release -y",
      "sudo yum install ansible -y"
    ]
  }

  network_interface {
    network = "default"
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

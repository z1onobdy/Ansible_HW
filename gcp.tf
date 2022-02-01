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
      "sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*",
      #"sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*",
      #"sudo yum install epel-release -y",
      #"sudo yum install ansible -y"
    ]
  }

  network_interface {
    network = "default"
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

resource "null_resource" "node_inctances_hosts_file" {
  count = "2"

  connection {
    type = "ssh"
    host = "${element(google_compute_instance.Node[*].network_interface[0].access_config[0].nat_ip, (count.index))}"
    user = "z10"
    private_key = file("privnew1")
  }
  provisioner "remote-exec" {
     inline = [
#     "echo '${join("\n", formatlist("%v", google_compute_instance.Node[*].network_interface[0].access_config[0].nat_ip))}' | awk 'BEGIN { print \"\\n\\n# test:\" }; { print $0 \" node\" NR\".example.com\"}' | sudo tee -a /etc/hosts",
      "echo '${join("\n", formatlist("%s %s", google_compute_instance.Node[*].network_interface[0].access_config[0].nat_ip, google_compute_instance.Node[*].hostname))}' | sudo tee -a /etc/hosts",
    ]
   }
}

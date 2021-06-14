# Configuración de provider
provider "google" {
  project = "ClasesUHU"
  region  = "europe-west1"
}

# Regla en cortafuegos
resource "google_compute_firewall" "instance" {
  name    = "practica4-terraform"
  network = "default"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

# Creación de máquina virtual
resource "google_compute_instance" "example" {
  name          = "practica4-webserver"
  machine_type  = "f1-micro"
  zone          = "europe-west1-b"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }
  
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  
  tags = ["practica4-terraform"]
  
  metadata_startup_script = "echo 'Hola Mundo' > index.html ; nohup busybox httpd -f -p 8080 &"
}

# Salida: IP publica
output "public_ip" {
  value = "${google_compute_instance.example.network_interface.0.access_config.0.assigned_nat_ip}"
}
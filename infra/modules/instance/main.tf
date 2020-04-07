# Create an image with the file we uploaded on Google Storage.
resource "google_compute_image" "mirage-demo-latest" {
  name   = "mirage-demo-latest"
  family = "mirage-demo"

  raw_disk {
    source = "https://storage.googleapis.com/${var.project_id}-images/mirage-demo-latest.tar.gz"
  }
}

# Create a static IP to access our instance.
resource "google_compute_address" "mirage-demo" {
  name = "mirage-demo-address"
  address_type = "EXTERNAL"
}

# Create a network for our project.
resource "google_compute_network" "vpc_network" {
  name                    = "mirage-demo-network"
  auto_create_subnetworks = "true"
}

# Create firewall rules for our network.
resource "google_compute_firewall" "default" {
  name    = "mirage-demo-firewall"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_tags = ["http-server"]
}

# Create a template to configure our instance with the image.
resource "google_compute_instance_template" "mirage-demo" {
  name_prefix           = "mirage-demo"
  machine_type   = "f1-micro"
  can_ip_forward = false

  tags = ["http-server"]

  disk {
    source_image = google_compute_image.mirage-demo-latest.self_link
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
      nat_ip = google_compute_address.mirage-demo.address
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create an instance group manager to spin up instances and unable rolling out updates.
resource "google_compute_instance_group_manager" "mirage-demo" {
  name = "mirage-demo-igm"
  zone = var.zone

  version {
    instance_template = google_compute_instance_template.mirage-demo.self_link
  }

  target_size        = "1"
  base_instance_name = "mirage-demo"
}
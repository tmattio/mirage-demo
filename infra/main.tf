terraform {
  backend "gcs" {
    bucket      = "mirage-demo-273420-tfstate"
    credentials = "account.json"
  }
}

provider "google" {
  credentials = file("account.json")
  project     = var.project_id
  region      = var.region

  version = "~> 3.6.0"

  # We need to disable batching to enable the APIs one by one
  batching {
    enable_batching = false
  }
}

module "global" {
  source = "./modules/global"

  region     = var.region
  project_id = var.project_id
}

module "instance" {
  source = "./modules/instance"

  zone       = var.zone
  project_id = var.project_id
}

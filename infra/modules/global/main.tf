# Creates a GCS bucket to store our MirageOS images.
resource "google_storage_bucket" "mirage" {
  name     = "${var.project_id}-images"
  location = var.region
  project  = var.project_id
}

# Create a service account for Github Actions to deploy our application.
resource "google_service_account" "github-actions" {
  account_id   = "github-actions"
  display_name = "A service account used in Github actions to deploy services."

  depends_on = [google_project_service.iam-api]
}

# Assign the appropriate permissions to Github Actions service account.
data "google_iam_policy" "github-actions" {
  binding {
    role = "roles/compute.instanceAdmin"
    members = [
      "serviceAccount:${google_service_account.github-actions.email}",
    ]
  }

  binding {
    role = "roles/storage.admin"
    members = [
      "serviceAccount:${google_service_account.github-actions.email}",
    ]
  }
}

# Create a key for Github Actions service account.
resource "google_service_account_key" "github-actions-key" {
  service_account_id = google_service_account.github-actions.id
}

# Enable the Cloud Resource Manager API, required to manage the other APIs.
resource "google_project_service" "cloudresourcemanager-api" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"

  disable_dependent_services = true
}

# Enable the Compute Engine API, required to create compute instances.
resource "google_project_service" "compute-api" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_dependent_services = true

  depends_on = [google_project_service.cloudresourcemanager-api]
}

# Enable the IAM API, required to create service accounts and assign them permissions.
resource "google_project_service" "iam-api" {
  project = var.project_id
  service = "iam.googleapis.com"

  disable_dependent_services = true

  depends_on = [google_project_service.cloudresourcemanager-api]
}

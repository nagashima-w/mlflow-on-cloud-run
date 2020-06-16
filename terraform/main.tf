variable "credentials-path" {}
variable "project-name" {}
variable "default-region" {}
variable "suffix" {}
variable "image-name" {}
variable "file-dir" {
    default = "files"
}
variable "cloud-run-service-account" {}
variable "user" {}

provider "google" {
  credentials = file(var.credentials-path)
  project     = var.project-name
  region      = var.default-region
}

resource "google_storage_bucket" "artifact-bucket" {
  name     = "artifact-bucket-${var.suffix}"
  location = var.default_region
}

resource "google_cloud_run_service" "mlflow" {
  name     = "mlflow-container"
  location = var.default_region
  template {
    spec {
      containers {
        image = var.image-name
        env {
          name  = "FILE_DIR"
          value = var.file-dir
        }
        env {
          name  = "GCS_BUCKET"
          value = google_storage_bucket.artifact-bucket.name
        }
      }
      service_account_name = var.cloud-run-service-account
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service_iam_binding" "binding" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name
  role     = "roles/viewer"
  members = [
    "user:${var.user}",
  ]
}
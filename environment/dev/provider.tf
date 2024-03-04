provider "google" {
  project = var.project_id
  region = var.default_region
  zone = var.default_zone
}

terraform {
  backend "gcs" {
    bucket = "terrafrom-state3838"
    prefix = "terraform/state"
  }
}
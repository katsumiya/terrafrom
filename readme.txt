SAMPLE
main.tf
module "documentai" {
  source = "/Users/XXXX/Desktop/GCP/terrafrom/module/ai/documentai"
  
  # Basic variables
  project_id =var.project_id
  default_region = var.default_region

  # Naming conventions
  default_prefix = var.default_prefix
  default_env = var.default_env

  # cloud function

  # cloud storage
  default_storage_region = var.default_storage_region

}

variables.tf
# Basic
variable "project_id" {
  type = string
  default = "thinking-bonbon-413902"
}
variable "default_region" {
  type = string
  default = "asia-northeast1"
}
variable "default_zone" {
  type = string
  default = "asia-northeast1a"
}

# Naming
variable "default_prefix" {
  type = string
  default = "documentai"
}
variable "default_env" {
  type = string
  default = "dev"
}

# Storage
variable "default_storage_region" {
  type = string
  default = "ASIA-NORTHEAST1"
}
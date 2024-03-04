module "documentai" {
  source = "/Users/miyabayashikatsuyuki/Desktop/GCP/terrafrom/module/ai/documentai"
  
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
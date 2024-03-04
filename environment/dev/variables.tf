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
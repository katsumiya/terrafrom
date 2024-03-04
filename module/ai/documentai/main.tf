# cloud function
# localでPythonのzip作成
resource "google_storage_bucket" "storage_function" {
  name = "${var.default_prefix}-${var.default_env}-storage-fucntion"
  force_destroy = false
  location = var.default_storage_region
  storage_class = "STANDARD"
  public_access_prevention = "enforced"
  versioning {
    enabled = true
  }
}

data "archive_file" "zip_documentai_functionsource" {
  type = "zip"
  source_dir =  "${path.module}/python"
  output_path = var.artifact_output_path
}

resource "google_storage_bucket_object" "sotage_documentai_function" {
  name = "${var.default_prefix}-${var.default_env}-function-${data.archive_file.zip_documentai_functionsource.output_md5}-sourec.zip"
  bucket = google_storage_bucket.storage_function.name
  source = data.archive_file.zip_documentai_functionsource.output_path
}

resource "google_storage_bucket" "storage_data_source" {
  name = "${var.default_prefix}-${var.default_env}-storage-data"
  force_destroy = false
  location = var.default_storage_region
  storage_class = "STANDARD"
  public_access_prevention = "enforced"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "storage_data_processed" {
  name = "${var.default_prefix}-${var.default_env}-storage-dataprocessed"
  force_destroy = false
  location = var.default_storage_region
  storage_class = "STANDARD"
  public_access_prevention = "enforced"
  versioning {
    enabled = true
  }
}

resource "google_cloudfunctions2_function" "function_dc_v2" {
  name = "${var.default_prefix}-${var.default_env}-function1"
  location = var.default_region
  description = "document ai "
  build_config {
    runtime = "python312"
    entry_point = "main"
    source {
      storage_source {
        bucket = google_storage_bucket.storage_function.name
        object = google_storage_bucket_object.sotage_documentai_function.name
      }
    }
  }

  service_config {
    available_cpu = "1"
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    max_instance_request_concurrency = 100
    environment_variables = {
      document_ai_processor_id = google_document_ai_processor.processor.id,
      storage_data_processed = google_storage_bucket.storage_data_processed.id
    }
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_RETRY"
    event_filters {
      attribute = "bucket"
      value = google_storage_bucket.storage_data_source.name
    }
  }
}

resource "google_document_ai_processor" "processor" {
  location = "us"
  display_name = "${var.default_prefix}-${var.default_env}-processor"
  type = "OCR_PROCESSOR"
}
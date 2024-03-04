import json
import os
from datetime import datetime
from google.cloud import storage
from google.cloud import documentai_v1beta3

# 環境変数
document_ai_processor_id = os.environ.get("document_ai_processor_id")
storage_data_processed = os.environ.get("storage_data_processed")

def main(event, context):
    # Cloud Storageのイベント情報からバケット名とファイル名を取得
    bucket_name = event['bucket']
    file_name = event['name']
        
    # Document AIのクライアントを初期化
    client = documentai_v1beta3.DocumentProcessorServiceClient()
    

    # Initialize request argument(s)
    gcsDocument = documentai_v1beta3.GcsDocument(
        gcs_uri = f"gs://{bucket_name}/{file_name}",
        mime_type="application/pdf"  # ドキュメントのMIMEタイプを指定します
    )

    # gcsOutputConfig = documentai_v1beta3.DocumentOutputConfig.GcsOutputConfig(
    #     gcs_uri="gs://documentai-dev-storage-data-processed",  # 出力先のGCS URIを指定します
    #     field_mask = "document,pages"
    # )

    # DocumentOutputConfig =documentai_v1beta3.DocumentOutputConfig(
    #     gcs_output_config = gcsOutputConfig
    # )

    request = documentai_v1beta3.ProcessRequest(
        gcs_document = gcsDocument,
        name = "projects/thinking-bonbon-413902/locations/us/processors/94857ad810344ac2"
    )
    
    # ドキュメントを処理
    response = client.process_document(request=request)
    print(response.document)
    # Convert the response to JSON string
    response_json = response_to_json(response)

    # Upload response as JSON to Cloud Storage
    upload_response_to_gcs(response_json, file_name)


def response_to_json(response):
    # Convert the response object to dictionary
    response_dict = {
        "document": {
            "text": response.document.text,
            # Add other fields you want to include in the JSON
        },
        # Add other fields from the response if needed
    }
    
    # Convert dictionary to JSON string
    response_json = json.dumps(response_dict)
    return response_json


def upload_response_to_gcs(response_json, file_name):
    # Create a storage client
    storage_client = storage.Client()

    # Define the bucket and file name in Cloud Storage to upload the JSON file
    now = datetime.now().strftime("%Y_%m_%d_%H_%M")
    new_file_name = f"{os.path.splitext(file_name)[0]}_{now}_processed.json"
    destination_blob_name = f"{storage_data_processed}/{new_file_name}"

    # Upload the JSON content to Cloud Storage
    bucket = storage_client.bucket(storage_data_processed)
    blob = bucket.blob(new_file_name)
    blob.upload_from_string(response_json, content_type="application/json")
    print(f"Response uploaded to Cloud Storage: gs://{destination_blob_name}")


resource "aws_s3_bucket" "snowflake_ingestion" {
  bucket = "homelab-minio-mirror-raw"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "homelab-tf-state-prod"
}
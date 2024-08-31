# resource "snowflake_storage_integration" "local_minio_integration" {
#     storage_integration_name = "local_minio_integration"
#     storage_provider = "minio"
#     stage_name = "local_minio"
#     file_format = "json"
#     url = "http://localhost:9000"
#     path = "dbt-airflow"
# }
resource "snowflake_stage" "s3_minio_mirror" {
    name = "S3_MINIO_MIRROR"
    url = "s3://homelab-minio-mirror-raw"

    schema = snowflake_schema.raw.name
    database = snowflake_database.prod.name
    
    credentials = "AWS_KEY_ID='${var.S3_MINIO_MIRROR_USER_ACCESS_KEY}' AWS_SECRET_KEY='${var.S3_MINIO_MIRROR_USER_SECRET_KEY}'"
}

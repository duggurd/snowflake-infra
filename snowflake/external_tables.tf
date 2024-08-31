# resource "snowflake_external_table" "finn_metadata" {
#     name = "FINN_METADATA"
#     database = snowflake_database.prod.name
#     schema = snowflake_schema.raw.name
#     file_format = snowflake_file_format.gzip_parquet.name
#     location = "@${snowflake_stage.s3_minio_mirror.database}.${snowflake_stage.s3_minio_mirror.schema}.${snowflake_stage.s3_minio_mirror.name}"
#     column {
#         name = "date"
#         type = "string"
#         as = "METADATA$FILENAME"
#     }
# }


resource "snowflake_file_format" "gzip_parquet" {
    name = "gzip_parquet"
    format_type = "PARQUET"
    compression = "AUTO"
    database = snowflake_database.prod.name
    schema = snowflake_schema.raw.name
}
resource "snowflake_external_table" "s3_minio_mirror" {
    name = "EXTERNAL_S3_MINIO_MIRROR"
    database = snowflake_database.prod.name
    schema = snowflake_schema.raw.name
    file_format = "TYPE = PARQUET"
    location = "@${snowflake_stage.s3_minio_mirror.database}.${snowflake_stage.s3_minio_mirror.schema}.${snowflake_stage.s3_minio_mirror.name}"
    
    column {
        name = "source_file"
        type = "string"
        as = "METADATA$FILENAME"
    }
}


resource "snowflake_file_format" "gzip_parquet" {
    name = "GZIP_PARQUET"
    format_type = "PARQUET"
    compression = "AUTO"
    database = snowflake_database.prod.name
    schema = snowflake_schema.raw.name
}
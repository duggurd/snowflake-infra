CREATE OR REPLACE EXTERNAL VOLUME iceberg_external_volume
  STORAGE_LOCATIONS = (
    (
        NAME ='s3-eu-west-1'
        STORAGE_PROVIDER = 'S3'
        STORAGE_BASE_URl = 's3://homelab-minio-mirror-raw/iceberg/'
        STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::215219632580:role/sf_minio_mirror'
        STORAGE_AWS_EXTERNAL_ID = 'iceberg_external_id'
    )
  );

-- DESCRIBE EXTERNAL VOLUME iceberg_external_volume;

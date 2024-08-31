CREATE ICEBERG TABLE PROD.RAW.test_iceberg
    EXTERNAL_VOLUME = 'iceberg_external_volume'
    CATALOG = 'iceberg_integration'
    METADATA_FILE_PATH = 'metadata/00000-35697bfe-bd83-4eba-b3ad-f289846724f3.metadata.json';

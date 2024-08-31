resource "snowflake_database" "prod" {
    name = "PROD"
}

resource "snowflake_schema" "raw" {
    name = "RAW"
    database = snowflake_database.prod.name
}
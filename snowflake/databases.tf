resource "snowflake_database" "prod" {
    name = "PROD"
}

resource "snowflake_schema" "raw" {
    name = "RAW"
    database = snowflake_database.prod.name
}

resource "snowflake_schema" "security" {
    name = "SECURITY"
    database = snowflake_database.prod.name
}
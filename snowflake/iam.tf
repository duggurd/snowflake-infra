resource "snowflake_password_policy" "default" {
    name = "default"
    min_length = 8
    max_length = 64
    database = snowflake_database.prod.name
    schema = snowflake_schema.security.name
    min_lower_case_chars = 0
    min_upper_case_chars = 0
    min_numeric_chars = 0
    min_special_chars = 0
    or_replace = true
}

resource "snowflake_account_password_policy_attachment" "password_policy" {
  password_policy = snowflake_password_policy.default.qualified_name
}


# Roles
resource "snowflake_account_role" "platform" {
  name = "PLATFORM"
}

resource "snowflake_grant_privileges_to_account_role" "platform_account" {
  account_role_name = snowflake_account_role.platform.name
  with_grant_option = true
  on_account = true
  privileges = [ 
    "CREATE DATABASE",
    "CREATE EXTERNAL VOLUME",
    "CREATE INTEGRATION",
    "CREATE ROLE",
    "MANAGE WAREHOUSES",
    "MONITOR EXECUTION",
    "MONITOR USAGE",
    "READ SESSION",
    "RESOLVE ALL",
  ]
}

resource "snowflake_grant_privileges_to_account_role" "platform_prod" {
  account_role_name = snowflake_account_role.platform.name
  all_privileges = true
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.prod.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "platform_prod_public" {
  account_role_name = snowflake_account_role.platform.name
  all_privileges = true
  on_schema {
    schema_name = "${snowflake_database.prod.name}.PUBLIC"
  }
}

resource "snowflake_grant_privileges_to_account_role" "platform_prod_raw" {
  account_role_name = snowflake_account_role.platform.name
  all_privileges = true
  on_schema {
    schema_name = "${snowflake_schema.raw.database}.${snowflake_schema.raw.name}"
  }
}

resource "snowflake_grant_privileges_to_account_role" "platform_all_tables" {
  account_role_name = snowflake_account_role.platform.name
  all_privileges = true
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_database = snowflake_database.prod.name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "platform_all_stages" {
  account_role_name = snowflake_account_role.platform.name
  all_privileges = true
  on_schema_object {
    all {
      object_type_plural = "STAGES"
      in_database = snowflake_database.prod.name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "platform_all_views" {
  account_role_name = snowflake_account_role.platform.name
  all_privileges = true
  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_database = snowflake_database.prod.name
    }
  }
}


resource "snowflake_grant_privileges_to_account_role" "platform_all_et" {
  account_role_name = snowflake_account_role.platform.name
  all_privileges = true
  on_schema_object {
    all {
      object_type_plural = "EXTERNAL TABLES"
      in_database = snowflake_database.prod.name
    }
  }
}





resource "snowflake_grant_account_role" "platform" {
  role_name = snowflake_account_role.platform.name
  user_name = "DUGGURD"
}


# Users
resource "snowflake_user" "aliti_coding" {
  name = "ALITI-CODING"
  must_change_password = true
}

resource "snowflake_user" "glenroger" {
    name = "GLENROGER"
    must_change_password = true
}
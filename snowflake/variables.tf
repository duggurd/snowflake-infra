variable S3_MINIO_MIRROR_USER_ACCESS_KEY {
    type = string
    description = "Minio Access Key"
}

variable "S3_MINIO_MIRROR_USER_SECRET_KEY" {
  type = string
  description = "Minio Secret Key"
  sensitive = true
}
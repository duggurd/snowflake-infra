resource "aws_iam_user" "minio_mirror" {
    name = "minio_mirror_user"

}

# Documents
data "aws_iam_policy_document" "minio_mirror" {
    statement {
        sid = "1"
        actions = [
            "s3:ListBucket",
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
        ]
        resources = [
            "arn:aws:s3:::homelab-minio-mirror-raw",
            "arn:aws:s3:::homelab-minio-mirror-raw/*",
        ]
    }
}

data "aws_iam_policy_document" "snowflake_s3_mirror" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion"
    ]
    resources = ["${aws_s3_bucket.snowflake_ingestion.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = ["${aws_s3_bucket.snowflake_ingestion.arn}"]
    condition {
      test = "StringLike"
      variable = "s3:prefix"
      values = ["*"]
    }
  }
}

data "aws_iam_policy_document" "sf_minio_mirror_assume_role" {
    statement {
        effect = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type = "AWS"
            identifiers = ["arn:aws:iam::211125613752:user/externalstages/cibxx60000"]
        }
        condition {
         test = "StringEquals"
         values = [ "iceberg_external_id" ]
         variable = "sts:ExternalId"
        }
    }
}



# Policies
resource "aws_iam_user_policy" "minio_mirror" {
  name = "minio_mirror_user_policy"
  user = aws_iam_user.minio_mirror.name
  policy = data.aws_iam_policy_document.minio_mirror.json
}

resource "aws_iam_policy" "sf_minio_mirror" {
  policy = data.aws_iam_policy_document.snowflake_s3_mirror.json
}



# Roles
resource "aws_iam_role" "sf_minio_mirror" {
  name = "sf_minio_mirror"
  assume_role_policy = data.aws_iam_policy_document.sf_minio_mirror_assume_role.json
}

resource "aws_iam_role_policy_attachment" "minio_sf_mirror_attachment" {
  role = aws_iam_role.sf_minio_mirror.name
  policy_arn = aws_iam_policy.sf_minio_mirror.arn
}


resource "aws_iam_access_key" "minio_mirror" {
  user = aws_iam_user.minio_mirror.name
}

output "minio_mirror_access_key_secret" {
  value = aws_iam_access_key.minio_mirror.secret
  sensitive = true
}

output "minio_mirror_access_key_id" {
  value = aws_iam_access_key.minio_mirror.id
}



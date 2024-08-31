resource "aws_iam_user" "minio_mirror" {
    name = "minio_mirror_user"

}

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

resource "aws_iam_user_policy" "minio_mirror" {
  name = "minio_mirror_user_policy"
  user = aws_iam_user.minio_mirror.name
  policy = data.aws_iam_policy_document.minio_mirror.json
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
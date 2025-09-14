output "bucket_access" {
  value = {
    access-key = minio_iam_service_account.user.access_key
    secret-key = minio_iam_service_account.user.secret_key
    region     = "us-east-1"
  }
}
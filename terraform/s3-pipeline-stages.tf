# Bucket para armazenar os stages das pipelines de outros repositórios.
# Nome: <account_id>stageterraform (ex.: 123456789012stageterraform)
resource "aws_s3_bucket" "pipeline_stages" {
  bucket = "${data.aws_caller_identity.current.account_id}stageterraform"

  tags = {
    Name        = "${data.aws_caller_identity.current.account_id}stageterraform"
    Description = "Stages das pipelines de outros repositórios"
  }
}

resource "aws_s3_bucket_versioning" "pipeline_stages" {
  bucket = aws_s3_bucket.pipeline_stages.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_stages" {
  bucket = aws_s3_bucket.pipeline_stages.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pipeline_stages" {
  bucket = aws_s3_bucket.pipeline_stages.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

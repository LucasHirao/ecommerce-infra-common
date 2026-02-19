output "pipeline_stages_bucket_id" {
  description = "Nome do bucket S3 para stages das pipelines"
  value       = aws_s3_bucket.pipeline_stages.id
}

output "pipeline_stages_bucket_arn" {
  description = "ARN do bucket S3 para stages das pipelines"
  value       = aws_s3_bucket.pipeline_stages.arn
}

output "aws_account_id" {
  description = "ID da conta AWS onde o recurso foi criado"
  value       = data.aws_caller_identity.current.account_id
}

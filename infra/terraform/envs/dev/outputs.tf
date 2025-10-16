output "region" { value = var.aws_region }
output "bucket" { value = aws_s3_bucket.data.bucket }
output "dynamodb_table" { value = aws_dynamodb_table.ingestion.name }
output "sns_topic" { value = aws_sns_topic.alerts.arn }
output "lambda_exec_role" { value = aws_iam_role.lambda_exec.arn }

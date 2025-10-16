##Intérêt : ta Lambda pourra (1) lire S3 (gold), (2) lire/écrire DynamoDB (cache/state), (3) publier dans SNS (alertes), (4) écrire ses logs CloudWatch.


# Role d'exécution Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project}-lambda-exec-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

# Politique minimale custom (S3 read, DynamoDB R/W, SNS publish)
data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid     = "S3ReadDataLake"
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.data.arn,
      "${aws_s3_bucket.data.arn}/*"
    ]
  }

  statement {
    sid     = "DynamoRW"
    effect  = "Allow"
    actions = [
      "dynamodb:GetItem","dynamodb:PutItem","dynamodb:UpdateItem",
      "dynamodb:Query","dynamodb:Scan"
    ]
    resources = [ aws_dynamodb_table.ingestion.arn ]
  }

  statement {
    sid     = "SnsPublish"
    effect  = "Allow"
    actions = [ "sns:Publish" ]
    resources = [ aws_sns_topic.alerts.arn ]
  }

  statement {
    sid     = "CloudWatchLogs"
    effect  = "Allow"
    actions = [
      "logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"
    ]
    resources = [ "arn:aws:logs:${var.aws_region}:*:log-group:/aws/lambda/*" ]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${var.project}-lambda-policy-${var.env}"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec.arn
}

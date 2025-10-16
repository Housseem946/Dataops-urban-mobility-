locals {
  table_name = "${var.project}-ingestion-${var.env}"
}

resource "aws_dynamodb_table" "ingestion" {
  name         = local.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "source_watermark"

  attribute {
    name = "source_watermark"
    type = "S" # ex: "weather#<hash>" ou "navitia#<watermark>"
  }

  # TTL optionnel : on peut expirer les entrées après X jours
  ttl {
    attribute_name = "expires_at" # timestamp epoch (seconds)
    enabled        = true
  }
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.ingestion.name
}

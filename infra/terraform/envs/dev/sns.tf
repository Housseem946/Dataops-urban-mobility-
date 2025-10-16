locals {
  topic_name = "${var.project}-alerts-${var.env}"
}

resource "aws_sns_topic" "alerts" {
  name = local.topic_name
}

# Abonnement email (tu devras cliquer le lien de confirmation reçu)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

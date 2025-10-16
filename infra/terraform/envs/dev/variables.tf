variable "project" {
  description = "Dataops Urban mobility and weather insights"
  type        = string
  default     = "umwi"
}

variable "env" {
  description = "Environnement (dev|prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}

variable "alert_email" {
  description = "Email abonné aux alertes SNS (doit confirmer l'abonnement)"
  type        = string
}

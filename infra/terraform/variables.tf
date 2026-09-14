variable "gcp_project_id" {
  type        = string
  description = "GCP project this service is deployed into"
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}

variable "image_url" {
  type        = string
  description = "ghcr.io/<user>/<repo>:latest"
}



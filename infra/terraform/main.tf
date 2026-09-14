resource "google_service_account" "app_runtime" {
  account_id   = "tier1-app-runtime"
  display_name = "Tier 1 app runtime identity"
}

resource "google_cloud_run_v2_service" "app" {
  name     = "tier1-app"
  location = var.gcp_region

  template {
    service_account = google_service_account.app_runtime.email

    containers {
      image = var.image_url

      ports {
        container_port = 80
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
    }

    scaling {
      max_instance_count = 3
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  location = google_cloud_run_v2_service.app.location
  name     = google_cloud_run_v2_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}



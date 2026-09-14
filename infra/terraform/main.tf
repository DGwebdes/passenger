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

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
    ]
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  location = google_cloud_run_v2_service.app.location
  name     = google_cloud_run_v2_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}


resource "google_service_account" "deployer" {
  account_id    = "tier1-deployer"
  display_name  = "CI deploy identity (tier 1)"
}

resource "google_cloud_run_v2_service_iam_member" "deployer_access" {
  location  = google_cloud_run_v2_service.app.location
  name      = google_cloud_run_v2_service.app.name
  role      = "roles/run.developer"
  member    = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_service_account_iam_member" "deployer_can_use_runtime_sa" {
  service_account_id = google_service_account.app_runtime.name
  role              = "roles/iam.serviceAccountUser"
  member            = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_project_service" "sm_api" {
  service = "secretmanager.googleapis.com"
}

resource "google_cloud_run_service" "event_handler" {
  name     = "event-handler"
  location = var.google_region

  template {
    spec {
      containers {
        image = "gcr.io/${var.google_project_id}/event-handler"
        env {
          name  = "PROJECT_NAME"
          value = var.google_project_id
        }
      }
      service_account_name = google_service_account.fourkeys_service_account.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  depends_on = [
    google_project_service.run_api,
  ]

}

# resource "google_cloud_run_service_iam_binding" "noauth" {
#   location = var.google_region
#   project  = var.google_project_id
#   service  = "event-handler"

#   role       = "roles/run.invoker"
#   members    = ["allUsers"]
#   depends_on = [google_cloud_run_service.event_handler]
# }

resource "google_secret_manager_secret" "event-handler-secret" {
  secret_id = "event-handler"
  replication {
    automatic = true
  }
  depends_on = [google_project_service.sm_api]
}

resource "random_id" "event-handler-random-value" {
  byte_length = "20"
}

resource "google_secret_manager_secret_version" "event-handler-secret-version" {
  secret      = google_secret_manager_secret.event-handler-secret.id
  secret_data = random_id.event-handler-random-value.hex
}

resource "google_secret_manager_secret_iam_member" "event-handler" {
  secret_id = google_secret_manager_secret.event-handler-secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.fourkeys_service_account.email}"
}
resource "google_service_account" "gcp_integration" {
  account_id   = "gcp-integration-account"
  display_name = "GCP Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.gcp_integration.email
}

resource "google_project_iam_binding" "viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/viewer"

  # Reference the email of the service account from the output
  members = [
    "serviceAccount:${google_service_account.gcp_integration.email}",
  ]
}

resource "google_project_iam_binding" "token_creator_binding" {
  project = "PROJECT_ID"
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:CHECKRED_SERVICE_ACCOUNT_EMAIL",
  ]
}

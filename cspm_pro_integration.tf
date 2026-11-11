resource "google_service_account" "cspm_integration" {
  account_id   = "cspm-integration-account"
  display_name = "GCP CSPM Integration"
  project      = "PROJECT_ID"
}

# Output the email of the service account
output "service_account_email" {
  value = google_service_account.cspm_integration.email
}

resource "google_project_iam_binding" "viewer_binding" {
  project = "PROJECT_ID"
  role    = "roles/viewer"

  # Reference the email of the service account from the output
  members = [
    "serviceAccount:${google_service_account.cspm_integration.email}",
  ]
}

resource "google_project_iam_binding" "token_creator_binding" {
  project = "PROJECT_ID"
  role    = "roles/iam.serviceAccountTokenCreator"

  members = [
    "serviceAccount:SERVICE_ACCOUNT_EMAIL",
  ]
}
